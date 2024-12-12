import SwiftUI

struct BrandDetail: View {
    let brand: BrandModel
    @State private var expandedSection: String? = nil // 현재 확장된 섹션
    @State private var isLoading: Bool = false // 로딩 상태 표시
    @State private var notification: String? = nil // Firebase에서 가져온 상품고시정보 저장
    let delivery_policy = """
        배송지 입력 방법 :
        구매자가 선물 받는 분의 주소를 알고 계시는 경우 구매단계에서 배송지를 대신 입력할 수 있습니다.
        48시간이 지나면 자동으로 배송지 정보가 확정되어 구매자가 대신 입력한 배송지로 배송되며, 배송이 시작된 후에는 배송지 변경 및 취소가 불가능합니다.
        * 다만, 오픈채팅, 코드선물, 그룹선물, 선물게임의 경우는 배송지 대신 입력 기능 제공하지 않음
        배송 안내 :
        제품은 브랜드 측 협력사에서 사용하는 택배를 통해 개별 배송해 드립니다.
        배송은 배송지 입력 후 영업일 기준 2~5일 정도 소요됩니다. (배송기간은 협력사별로 상이할 수 있습니다.) 배송지역이 도서산간인 경우 또는 상품(가전/가구 등)에 따라서 추가 배송비가 실비로 청구될 수 있습니다.
        수취 거부 등의 고객님의 사유로 상품이 반송되는 경우 재배송이 제한될 수 있습니다.

        오기재 된 배송정보로 상품이 배송됨에 따른 책임은 배송주소를 실제 입력한 본인이 부담하며 회사가 별도의 배상 책임을 지지 않으므로 입력 전 배송정보를 정확히 확인하시기 바랍니다. 오기재 된 배송정보로 배송된 상품의 수신자와 제3자 간에 상품의 소유권 등에 관한 분쟁이 발생하는 경우 회사는 이에 관여하지 않으며 상품의 수신자와 해당 제3자가 해결하여야 합니다.
    """

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
                    expandableSection(title: "상품고시정보", content: brand.notification)
                    expandableSection(title: "배송지 입력 방법 및 배송안내", content: delivery_policy)
                    expandableSection(title: "교환/반품/환불 안내", content: brand.return_policy)
                    expandableSection(title: "구매 시 주의사항", content: brand.purchase_notice)
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
    func expandableSection(title: String, content: String?) -> some View {
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
                if isLoading && title == "상품고시정보" {
                    ProgressView("로딩 중...")
                        .padding(.top, 4)
                } else if let content = content, !content.isEmpty {
                    Text(content)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                } else {
                    Text("내용을 가져올 수 없습니다.")
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
