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
    //@State private var fruits:[Fruit]=[]
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                    .padding(.top, 45)
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
                        ForEach(brands, id: \.brandid) { brand in
                            FruitCardView(brand: brand)
                        }
                    }
                    .padding(.horizontal, 4)
                    
                }

            }
            .onAppear {
                fetchBrandIDsAndDetails() // Firestore에서 브랜드 ID 가져오기
            }
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
}

#Preview {
    CustomerHome()
}
