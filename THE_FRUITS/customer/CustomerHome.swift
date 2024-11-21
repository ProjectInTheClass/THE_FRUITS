import SwiftUI

struct FruitItem: Identifiable {
    var id: String
    var name: String
    var imageUrl: String
    var tags: [String]
    var likes: Int
}

struct CustomerHome: View {
    @State private var searchText: String = ""
    @State private var fetchedBrandIDs: [String] = [] // 초기값 설정
    @State private var brands:[BrandModel]=[]
    @State private var fruits:[FruitItem]=[]
        

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
                        ForEach(fruits) { fruit in
                            FruitCardView(brand: fruit)
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
                //print("Fetched Brand IDs: \(brandIDs)") // 디버그 출력
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
                    
                    firestoreManager.fetchBrand(brandId: brandID) { brand in
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
                    self.convertBrandsToFruits()
                }
            }
        }
    }
    
    // brands 배열을 FruitItem 배열로 변환
     func convertBrandsToFruits() {
         self.fruits = brands.map { brand in
             FruitItem(
                 id: brand.brandid, // BrandModel의 ID를 사용
                 name: brand.name,  // BrandModel의 이름을 사용
                 imageUrl: brand.logo, // BrandModel의 로고를 이미지 URL로 사용
                 tags: [], // 태그는 비워 두거나, 필요하면 추가 로직 구현
                 likes: brand.likes // BrandModel의 좋아요 수를 사용
             )
         }
         print("Fruits generated from Brands: \(self.fruits)")
     }
}

#Preview {
    CustomerHome()
}
