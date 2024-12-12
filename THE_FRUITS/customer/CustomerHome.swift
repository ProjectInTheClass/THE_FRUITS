import SwiftUI

struct BrandItem: Identifiable {
    var id: String{brandid}
    let brandid:String
    let name: String
    let logo: String
    let sigtype: [String]
    let likes: Int
    
    init(brandid: String, name: String, logo: String, sigtype: [String], likes: Int) {
        self.brandid = brandid
        self.name = name
        self.logo = logo
        self.sigtype = sigtype
        self.likes = likes
    }
}
struct CustomerHome: View {
    @State private var searchText: String = ""
    @State private var fetchedBrandIDs: [String] = [] // 초기값 설정
    @State private var brands:[BrandModel]=[]
    @State private var brandItems: [BrandItem] = []
    @State private var navigateToCustomerCart = false // 장바구니 화면 이동상태
    @State private var brandLikes: [String: Bool] = [:] // 브랜드 ID별 좋아요 상태 관리

    //@State private var fruits:[Fruit]=[]
    
    // 필터링 로직을 computed property로 분리
    var filteredBrands: [BrandModel] {
        if searchText.isEmpty {
            return brands
        } else {
            let lowercasedSearchText = searchText.lowercased()
            return brands.filter { brand in
                let nameContains = brand.name.lowercased().contains(lowercasedSearchText)
                let sigtypeContains = brand.sigtype?.contains(where: { $0.lowercased().contains(lowercasedSearchText) }) ?? false
                return nameContains || sigtypeContains
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("The Fruits")
                    .font(.custom("Magnolia Script", size: 40))
                    .foregroundColor( Color("darkGreen"))
                SearchBar(searchText: $searchText)
                    //.padding(.top, 5)
                    .padding(.bottom, 6)
                HStack {
                    CustomButton(
                        title: "최신등록순",
                        background: Color(UIColor(red: 217 / 255, green: 217 / 255, blue: 217 / 255, alpha: 1.0)),
                        foregroundColor: .black,
                        width: 55,
                        height: 30,
                        size: 8.5,
                        cornerRadius: 13,
                        icon: Image(systemName: "arrow.up.arrow.down"),
                        iconWidth: 10,
                        iconHeight: 10
                    ) {
                        print("정렬버튼 클릭!")
                    }
                    Spacer()
                }
                .padding(.leading, 12)
                .padding(.bottom, 10)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(filteredBrands, id: \.brandid) { brand in
                            FruitCardView(
                                brand: brand,
                                isLiked: Binding(
                                    get: { self.brandLikes[brand.brandid] ?? false },
                                    set: { self.brandLikes[brand.brandid] = $0 }
                                )
                            ) { newLikedStatus in
                                updateLikeStatus(for: brand.brandid, isLiked: newLikedStatus)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    CartToolbar(navigateToCart: $navigateToCustomerCart)
                }
            }
            //.navigationTitle("TheFruits")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear {
                fetchBrandIDsAndDetails() // Firestore에서 브랜드 ID 가져오기
                // 좋아요 여부 확인
                fetchBrandsAndLikes()
                
                // 지연 후 brandLikes 확인
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    print("brandLikes after fetch: \(self.brandLikes)")
                }
            }
            .background(
                NavigationLink(
                    destination: CustomerCart(), // 이동할 뷰
                    isActive: $navigateToCustomerCart, // 상태 관리
                    label: { EmptyView() }
                )
            )
            
        }
    }
    
    // Firestore에서 브랜드 ID 가져오기
    func fetchBrandIDs() {
        let firestoreManager = FireStoreManager()
        firestoreManager.fetchBrandIDs { brandIDs in
            DispatchQueue.main.async {
                self.fetchedBrandIDs = brandIDs
                print("Fetched Brand IDs: \(brandIDs)") // 디버그 출력
            }
        }
    }
    
    func fetchBrandIDsAndDetails() {
        let firestoreManager = FireStoreManager()
        
        firestoreManager.fetchBrandIDs { brandIDs in
            DispatchQueue.main.async {
                guard !brandIDs.isEmpty else {
                    print("No Brand IDs found!")
                    return
                }
                
                let group = DispatchGroup()
                var fetchedBrands: [BrandModel] = []
                
                for brandID in brandIDs {
                    group.enter()
                    print("Fetching details for Brand ID: \(brandID)")
                    
                    firestoreManager.fetchBrand(brandid: brandID) { brand in
                        if let brand = brand {
                            print("Fetched Brand: \(brand)")
                            fetchedBrands.append(brand)
                        } else {
                            print("Failed to fetch brand for ID: \(brandID)")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self.brands = fetchedBrands
                    print("All brands fetched: \(self.brands)")
                    self.brandItems=self.convertBrandsToFruits()
                }
            }
        }
    }
    
    // brands 배열을 FruitItem 배열로 변환
    func convertBrandsToFruits() -> [BrandItem] {
        return brands.map { brand in
            BrandItem(
                brandid:brand.brandid,
                name: brand.name,
                logo: brand.logo,
                sigtype: brand.sigtype ?? [], // 기본값 처리
                likes: brand.likes
            )
        }
    }
    
    //해당 브랜드가 brandlike 배열에 포함된 항목인지 아닌지 핀별하는 함수
    func checkBrandIsLiked(brandid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let firestoreManager = FireStoreManager()
        firestoreManager.fetchCustomerLikes { result in
            switch result {
            case .success(let brandLikes):
                // brandlike 배열에 brandid가 포함되어 있는지 확인
                let isLiked = brandLikes.contains(brandid)
                completion(.success(isLiked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchBrandsAndLikes() {
        let firestoreManager = FireStoreManager()
        firestoreManager.fetchBrandIDs { brandIDs in
            guard !brandIDs.isEmpty else {
                print("No Brand IDs found!")
                return
            }
            let group = DispatchGroup()
            var fetchedBrands: [BrandModel] = []

            for brandID in brandIDs {
                group.enter()
                firestoreManager.fetchBrand(brandid: brandID) { brand in
                    if let brand = brand {
                        fetchedBrands.append(brand)
                        group.enter() // 좋아요 상태 확인을 위한 enter
                        self.checkBrandIsLiked(brandid: brandID) { result in
                            if case .success(let isLiked) = result {
                                DispatchQueue.main.async {
                                    self.brandLikes[brandID] = isLiked
                                }
                            }
                            group.leave() // 좋아요 상태 확인 후 leave
                        }
                    }
                    group.leave() // 브랜드 정보 fetch 후 leave
                }
            }
            group.notify(queue: .main) {
                self.brands = fetchedBrands
            }
        }
        //print("brandLikes: \(brandLikes)");
        
    }


    func updateLikeStatus(for brandID: String, isLiked: Bool) {
        let firestoreManager = FireStoreManager()
        firestoreManager.updateCustomerLikes(brandid: brandID, add: isLiked)
    }
}

#Preview {
    CustomerHome()
}
