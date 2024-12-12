import SwiftUI

struct OrderProdcutSection: View {
    var orderList: [OrderSummary]
    var order: OrderModel?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6))
                .frame(width: UIScreen.main.bounds.width - 30)
                
            
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
            .frame(maxWidth: UIScreen.main.bounds.width - 48)
        }
    }
}

struct CustomerInfoView: View {
    @Binding var order: OrderModel? // 상위에서 관리되는 `order`를 바인딩으로 전달
    @EnvironmentObject var firestoreManager: FireStoreManager

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6)) // 배경색 설정
                .frame(width: UIScreen.main.bounds.width - 30) // 동일한 너비 설정

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("주문자 정보")
                    Spacer()
                    NavigationLink(
                        destination: CustomerOrderEditInfo(order: $order)
                            .onDisappear {
                                Task {
                                    // Firestore에서 최신 데이터를 가져오기
                                    if let orderId = order?.orderid {
                                        do {
                                            let (updatedOrder, _, _) = try await firestoreManager.fetchOrder(orderId: orderId)
                                            self.order = updatedOrder
                                        } catch {
                                            print("Error fetching updated order: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                    ) {
                        Text("변경")
                            .foregroundColor(Color.blue)
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
                        Text(order?.customername ?? "정보 없음")
                            .foregroundColor(.black)
                    }
                    HStack {
                        Text("휴대폰")
                            .foregroundColor(.black)
                        Spacer()
                        Text(order?.customerphone ?? "정보 없음")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.vertical, 15)
            .frame(maxWidth: UIScreen.main.bounds.width - 48) // VStack 너비 제한
        }
        .onAppear {
            Task {
                if let orderId = order?.orderid {
                    do {
                        let (updatedOrder, _, _) = try await firestoreManager.fetchOrder(orderId: orderId)
                        self.order = updatedOrder
                    } catch {
                        print("Error fetching order on appear: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


struct ShippingInfoView: View {
    @Binding var order: OrderModel? // 상위에서 관리되는 `order`를 바인딩으로 전달
    @EnvironmentObject var firestoreManager: FireStoreManager

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6))
                .frame(width: UIScreen.main.bounds.width - 30)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("배송지 정보")
                    Spacer()
                    NavigationLink(
                        destination: CustomerOrderEditAddress(order: $order)
                            .onDisappear {
                                Task {
                                    // Firestore에서 최신 데이터를 가져오기
                                    if let orderId = order?.orderid {
                                        do {
                                            let (updatedOrder, _, _) = try await firestoreManager.fetchOrder(orderId: orderId)
                                            self.order = updatedOrder
                                        } catch {
                                            print("Error fetching updated order: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                    ) {
                        Text("변경")
                            .foregroundColor(Color.blue)
                    }
                }

                Divider()
                    .frame(height: 1)
                    .overlay(Color.black)

                // 배송지 정보 표시
                VStack(alignment: .leading, spacing: 5) {
                    Text(order?.recaddress ?? "정보 없음")
                        .foregroundColor(.black)
                        .font(.system(size: 16))

                    Text("\(order?.recname ?? "정보 없음") | \(order?.recphone ?? "정보 없음")")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 15)
            .frame(maxWidth: UIScreen.main.bounds.width - 48)
        }
        .onAppear {
            Task {
                if let orderId = order?.orderid {
                    do {
                        let (updatedOrder, _, _) = try await firestoreManager.fetchOrder(orderId: orderId)
                        self.order = updatedOrder
                    } catch {
                        print("Error fetching order on appear: \(error.localizedDescription)")
                    }
                }
            }
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
    var orderList: [OrderSummary]
    @State var order: OrderModel?
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var brand: BrandModel?
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 브랜드 정보
                HStack {
                    if let brand = brand {
                        BrandButton(brand: brand)
                    } else {
                        Text("Loading brand information...")
                    }
                    Spacer()
                    Text("주문번호 : \(order?.ordernum ?? "주문 번호 없음")")
                        .font(.custom("Pretendard-Regular", size: 17))
                        .foregroundColor(.black)
                        .padding(.trailing, 10)
                }
                .frame(width: UIScreen.main.bounds.width - 30)

                // 컴포넌트 섹션들
                OrderProdcutSection(orderList: orderList, order: order)
                CustomerInfoView(order: $order)
                ShippingInfoView(order: $order)
                PaymentInfoView(order: order)
                PaymentAmountView(order: order)

                // Firestore 저장 버튼
                Button(action: {
                    Task {
                        guard let order = order else {
                            alertMessage = "주문 정보가 없습니다."
                            showAlert = true
                            return
                        }
                        do {
                            // Firestore에 데이터 저장
                            try await firestoreManager.saveOrderToFirestore(order: order)
                            alertMessage = "주문이 성공적으로 완료되었습니다."
                        } catch {
                            alertMessage = "주문 저장 중 오류가 발생했습니다: \(error.localizedDescription)"
                        }

                        // Alert 창 표시
                        showAlert = true
                    }
                }) {
                    Text("주문 완료하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("darkGreen"))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .alert(isPresented: $showAlert) { // Alert 창
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인"), action: {
                            if alertMessage == "주문이 성공적으로 완료되었습니다." {
                                dismiss() // 이전 페이지로 이동
                            }
                        })
                    )
                }
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

    
