import SwiftUI

struct OrderProdcutSection: View {
    var orderList: [OrderSummary] // 주문 상품 목록
    var order: OrderModel?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6))
                .frame(width: UIScreen.main.bounds.width - 30)
                //.padding(.horizontal) // 뷰 외부에 여백 추가
            
            VStack {
                HStack{
                    Text("주문 상품")
                    Spacer()
                }
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black)
                
                ForEach(orderList, id: \.orderprodid) { orderSummary in
                    VStack(alignment: .leading) {
                        ForEach(orderSummary.products, id: \.productid) { product in
                            HStack {
                                // 상품 이름
                                Text(product.productName)
                                    .font(.body)
                                Spacer()
                                Text("\(product.price)원 | \(product.num)개")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                        if orderSummary != orderList.last {
                            Divider() 
                                .background(Color.gray)
                                .padding(.vertical, 5)
                        }
                    }
                }
            }
            .padding(.vertical, 15)
            .frame(maxWidth: UIScreen.main.bounds.width - 48) // VStack 너비 제한
        }
    }
}
struct CustomerInfoView: View {
    var order: OrderModel?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6)) // 배경색 설정
                .frame(width: UIScreen.main.bounds.width - 30) // 동일한 너비 설정

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("주문자 정보")
                    Spacer()
                    Button(action: {
                        print("변경 버튼 클릭")
                    }) {
                        Text("변경")
                    }
                }
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("보내는 분")
                            .foregroundColor(.black)
                        Spacer()
                        Text(order?.recname ?? "정보 없음")
                            .foregroundColor(.black)
                    }
                    HStack {
                        Text("휴대폰")
                            .foregroundColor(.black)
                        Spacer()
                        Text(order?.recphone ?? "정보 없음")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.vertical, 15)
            .frame(maxWidth: UIScreen.main.bounds.width - 48) // VStack 너비 제한
        }
    }
}

struct ShippingInfoView: View {
    var order: OrderModel?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6)) // 배경색
                .frame(width: UIScreen.main.bounds.width - 30) // 너비 조정
            
            VStack(alignment: .leading, spacing: 10) {
                // 제목과 변경 버튼
                HStack {
                    Text("배송지 정보")
                        
                    Spacer()
                    Button(action: {
                        print("배송지 변경 클릭")
                    }) {
                        Text("변경")
                            
                            .foregroundColor(Color.blue)
                    }
                }

                Divider()
                    .frame(height: 1)
                    .overlay(Color.black)

                // 배송지 상세 정보
                VStack(alignment: .leading, spacing: 5) {
                    Text(order?.recaddress ?? "정보 없음") // 주소
                        .foregroundColor(.black)

                    Text("\(order?.recname ?? "정보 없음") | \(order?.recphone ?? "정보 없음")") // 이름 및 연락처
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical, 15)
            .frame(maxWidth: UIScreen.main.bounds.width - 48) // VStack 너비 제한
        }
    }
}

struct PaymentInfoView: View {
    var order: OrderModel?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6)) // 배경색
                .frame(width: UIScreen.main.bounds.width - 30) // 너비 설정
            
            VStack(alignment: .leading, spacing: 10) {
                // 제목
                HStack {
                    Text("결제 방법")
                    Spacer()
                }

                Divider()
                    .frame(height: 1)
                    .overlay(Color.black)

                // 결제 정보
                VStack(alignment: .leading, spacing: 5) {
                    Text("무통장 입금")
                        .foregroundColor(.black)
                        
                    Text("\(order?.bank ?? "정보 없음") \(order?.account ?? "정보 없음") \(order?.recname ?? "정보 없음")")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 15)
            .frame(maxWidth: UIScreen.main.bounds.width - 48) // VStack 너비 제한
        }
    }
}

struct PaymentAmountView: View {
    var order: OrderModel?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6)) // 배경색 설정
                .frame(width: UIScreen.main.bounds.width - 30) // 너비 설정
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("결제 금액")
                    Spacer()
                }

                Divider()
                    .frame(height: 1)
                    .overlay(Color.black)

                // 결제 금액 정보
                VStack(alignment: .leading, spacing: 10) {
                    // 주문 금액
                    HStack {
                        Text("주문 금액")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(formattedPrice(order?.totalprice ?? 0)) 원")
                            .foregroundColor(.black)
                    }

                    // 배송비
                    HStack {
                        Text("배송비")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(formattedPrice(order?.delcost ?? 0)) 원")
                            .foregroundColor(.black)
                    }

                    Divider()
                        .background(Color.gray)

                    // 최종 결제 금액
                    HStack {
                        Text("최종결제금액")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(formattedPrice((order?.totalprice ?? 0) + (order?.delcost ?? 0))) 원")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.vertical, 15) // 내부 여백
            .padding(.horizontal, 10) // 좌우 여백
        }
        .padding(.horizontal) // 외부 여백
    }

    // 금액 포맷팅 함수
    private func formattedPrice(_ price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: price)) ?? "0"
    }
}


struct CustomerOrder: View {
    var orderList: [OrderSummary] // 주문 상품 목록
    var order: OrderModel?
    
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var brand: BrandModel?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 브랜드 정보
                if let brand = brand {
                    BrandButton(brand: brand)
                } else {
                    Text("Loading brand information...")
                }
                
                // 컴포넌트 섹션들
                OrderProdcutSection(orderList: orderList, order: order)
                CustomerInfoView(order: order)
                ShippingInfoView(order: order)
                PaymentInfoView(order: order)
                PaymentAmountView(order: order)
            }
            .padding()
            .onAppear {
                Task {
                    guard let brandId = order?.brandid else {
                        print("Brand ID is missing")
                        return
                    }
                    do {
                        brand = try await firestoreManager.asyncFetchBrand(brandId: brandId)
                    } catch {
                        print("Failed to fetch brand: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


