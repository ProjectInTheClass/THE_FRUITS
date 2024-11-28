import SwiftUI

struct BrandDetail: View {
    let brand:BrandModel
    //let brandid:String
//    let storeName: String
//    var description: String = "새콤달콤한 과즙의 향연"
//    var detailText: String = """
//    특유의 달콤함으로 기분까지 좋게 만들어주죠. 제주 농협의 통합 브랜드, 골로장생이 맛 좋은 감귤을 엄선해 준비했습니다. 꼼꼼한 선별을 통해 새콤달콤한 맛이 눈으로도 느껴질 만큼 탐스럽게 익은 감귤인데요, 껍질질을 벗기면 상품한 균형감까지 느껴져요. 작은 조각을 입안으로 쏙 넣고 깨물면 새콤달콤한 과즙이 한뭉치 터져나옵니다. 생과일은 물론 디저트의 토핑으로도 제격일 거예요. [스토어 정보]
//    """
//    var imageUrl: String = "https://firebasestorage.googleapis.com/v0/b/thefruits-f8886.firebasestorage.app/o/IMG_0969.jpg?alt=media&token=56046c41-b210-401a-a4b1-0a6a74f1c1d6"

    @State private var expandedSection: String? = nil // 현재 확장된 섹션
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 헤더 섹션: 이미지와 제목
                VStack {
                    AsyncImage(url: URL(string: brand.logo)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .frame(height: 300)
                    }

                    Text("[\(brand.name)]")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                }
                
                // 텍스트 설명 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text(brand.slogan)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)

                    Text(brand.info)
                        .font(.body)
                        .foregroundColor(Color.black)
                        .lineSpacing(5)
                        .padding(.top, 8)
                }
                .padding(.horizontal)

                // 접을 수 있는 메뉴 섹션
                VStack(spacing: 12) {
                    expandableSection(title:brand.notification)
                    expandableSection(title:"배송지 입력 방법 및 배송안내")
                    expandableSection(title:brand.return_policy)
                    expandableSection(title: brand.purchase_notice)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
        }
        .navigationTitle(brand.name)
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Cart button clicked")
                }) {
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    @ViewBuilder
    func expandableSection(title: String) -> some View {
        VStack {
            Button(action: {
                withAnimation {
                    expandedSection = expandedSection == title ? nil : title
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: expandedSection == title ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            
            if expandedSection == title {
                Text("여기에 \(title)의 세부 정보가 들어갑니다.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

//#Preview {
//    
//    NavigationView {
//        BrandDetail(brandid:"dfdse", storeName:"온브릭스")
//            //.environmentObject(FireStoreManager())
//    }
//}
