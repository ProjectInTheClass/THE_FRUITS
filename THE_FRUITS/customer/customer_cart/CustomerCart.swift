import SwiftUI

struct CartSummaryView: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @Binding var selectedTotal: Int // 선택된 총합을 바인딩으로 전달받음
    @Binding var orderSummaries: [OrderSummary]
    @State private var isLoading = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6))
                .frame(width: UIScreen.main.bounds.width - 30)
            VStack {
                if isLoading {
                    Text("Loading cart details...")
                        .padding(5)
                } else {
                    ForEach(orderSummaries.indices, id: \.self) { summaryIndex in
                        VStack {
                            HStack {
                                ZStack {
                                    Button(action: {
                                        Task {
                                            do {
                                                // Firestore 업데이트
                                                try await firestoreManager.updateOrderProdSelected(orderprodId: orderSummaries[summaryIndex].orderprodid)
                                                orderSummaries = try await firestoreManager.fetchCartDetails()
                                                updateSelectedTotal()
                                            } catch {
                                                print("Error updating order product: \(error.localizedDescription)")
                                            }
                                        }
                                    }) {
                                        Circle()
                                            .stroke(Color("darkGreen"), lineWidth: 1.5)
                                            .frame(width: 15, height: 15)
                                            .overlay(
                                                orderSummaries[summaryIndex].selected
                                                    ? Circle().fill(Color("darkGreen")).frame(width: 10, height: 10)
                                                    : nil
                                            )
                                    }
                                }
                                Spacer()

                                Button(action: {
                                    Task {
                                        do {
                                            try await firestoreManager.deleteOrderProd(orderprodId: orderSummaries[summaryIndex].orderprodid)

                                            // 로컬 데이터에서 삭제
                                            orderSummaries.remove(at: summaryIndex)
                                            updateSelectedTotal() // 총합 업데이트
                                        } catch {
                                            print("Error deleting orderprodid \(orderSummaries[summaryIndex].orderprodid): \(error.localizedDescription)")
                                        }
                                    }
                                }) {
                                    Text("x")
                                        .font(.system(size: 23))
                                        .foregroundColor(Color("darkGreen"))
                                }
                            }

                            // Product 리스트 렌더링
                            ForEach(Array(orderSummaries[summaryIndex].products.enumerated()), id: \.element.productid) { index, product in
                                HStack {
                                    HStack(spacing: 5) {
                                        Text(product.productName)
                                            .font(.system(size: 16))
                                        Spacer()
                                        Text("\(product.price)원")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            if orderSummaries[summaryIndex].products[index].num > 1 {
                                                Task {
                                                    do {
                                                        // 수량 감소
                                                        orderSummaries[summaryIndex].products[index].num -= 1
                                                        try await firestoreManager.updateOrderProdQuantity(
                                                            orderprodId: orderSummaries[summaryIndex].orderprodid,
                                                            productId: product.productid,
                                                            newQuantity: orderSummaries[summaryIndex].products[index].num
                                                        )
                                                        updateSelectedTotal()
                                                    } catch {
                                                        print("Error updating quantity")
                                                    }
                                                }
                                            }
                                        }) {
                                            Text("-")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                        }
                                        Text("\(orderSummaries[summaryIndex].products[index].num)")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white)
                                        Button(action: {
                                            Task {
                                                do {
                                                    // 수량 증가
                                                    orderSummaries[summaryIndex].products[index].num += 1
                                                    try await firestoreManager.updateOrderProdQuantity(
                                                        orderprodId: orderSummaries[summaryIndex].orderprodid,
                                                        productId: product.productid,
                                                        newQuantity: orderSummaries[summaryIndex].products[index].num
                                                    )
                                                    updateSelectedTotal()
                                                } catch {
                                                    print("Error updating quantity")
                                                }
                                            }
                                        }) {
                                            Text("+")
                                                .font(.system(size: 15))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(width: 60, height: 25)
                                    .background(Color("darkGreen"))
                                    .cornerRadius(20)
                                }
                            }
                            Divider()
                                .background(Color.gray)
                                .padding(.vertical, 5)
                        }
                    }


                }
            }
            .padding(10)
        }
        .onAppear {
            Task {
                do {
                    orderSummaries = try await firestoreManager.fetchCartDetails()
                    isLoading = false
                    updateSelectedTotal()
                } catch {
                    print("Error loading cart details: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateSelectedTotal() {
        selectedTotal = orderSummaries.reduce(0) { total, summary in
            if summary.selected {
                let productTotal = summary.products.reduce(0) { $0 + ($1.price * $1.num) }
                return total + productTotal
            }
            return total
        }
    }
}
struct PriceSection: View {
    @Binding var orderAmount: Int // 주문 금액
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var delCost: Int? = nil // 배송비를 비동기로 업데이트
    var totalAmount: Int {
        orderAmount + (delCost ?? 0) // delCost가 nil이면 0으로 처리
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(UIColor.systemGray6))
            .frame(width: UIScreen.main.bounds.width - 30, height: 200)
            .overlay(
                VStack(spacing: 10) {
                    Text("결제 금액")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    Divider()
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("주문 금액")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Text("\(orderAmount) 원")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                        
                        HStack {
                            Text("배송비")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Text("\(delCost != nil ? "\(delCost!) 원" : "로딩 중...")")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("최종결제금액")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        Text("\(totalAmount) 원")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.vertical, 10)
            )
            .onAppear {
                Task {
                    delCost = await firestoreManager.getDelCost() // 배송비를 비동기로 가져옴
                }
            }
    }
}


struct CustomerCart: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var isLoading: Bool = true
    @State private var selectedTotal: Int = 0
    @State private var orderSummaries: [OrderSummary] = []
    @State private var brand: BrandModel?
    @State private var orderList: [OrderSummary] = []
    @State private var order: OrderModel?
    @State private var navigateToOrder = false // 네비게이션 상태 추가

    var body: some View {
        Group {
            if isLoading {
                VStack {
                    ProgressView("Loading Cart...")
                        .padding()
                }
            } else {
                if let brand = brand {
                    ScrollView {
                        VStack(spacing: 15) {
                            BrandButton(brand: brand)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            CartSummaryView(
                                selectedTotal: $selectedTotal,
                                orderSummaries: $orderSummaries
                            )
                            PriceSection(orderAmount: $selectedTotal)
                            CustomButton(
                                title: "주문하기",
                                background: Color("darkGreen"),
                                foregroundColor: .white,
                                width: 140,
                                height: 33,
                                size: 14,
                                cornerRadius: 15,
                                action: {
                                    Task {
                                        do {
                                            (order, orderList) = try await firestoreManager.createOrderModel(
                                                brand: brand,
                                                orderSummaries: orderSummaries,
                                                totalPrice: selectedTotal
                                            )
                                            
                                            navigateToOrder = true
                                        } catch {
                                            print("Error adding order: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            )
                            .navigationDestination(isPresented: $navigateToOrder) {
                                CustomerOrder(orderList: orderList, order: order)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                } else {
                    // 장바구니가 비었을 때 UI
                    VStack {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        Text("장바구니가 비었습니다.")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .padding(.vertical, 50)
                }
            }
        }
        .onAppear {
            Task {
                // 상태 재검증 및 초기화
                await reloadCartState()
            }
        }
    }
    
    /// 장바구니 상태를 다시 로드하는 함수
    private func reloadCartState() async {
        isLoading = true
        do {
            await firestoreManager.fetchCart()
            
            if await firestoreManager.isCartBrandAvailable() {
                brand = await firestoreManager.getCartBrand()
                orderSummaries = try await firestoreManager.fetchCartDetails()
                updateSelectedTotal()
            } else {
                // 브랜드와 장바구니 데이터 초기화
                brand = nil
                orderSummaries = []
                selectedTotal = 0
            }
        } catch {
            print("Error reloading cart state: \(error.localizedDescription)")
            // 오류가 발생하면 기본 상태로 초기화
            brand = nil
            orderSummaries = []
            selectedTotal = 0
        }
        isLoading = false
    }
    
    /// 선택된 총합 업데이트 함수
    private func updateSelectedTotal() {
        selectedTotal = orderSummaries.reduce(0) { total, summary in
            if summary.selected {
                let productTotal = summary.products.reduce(0) { $0 + ($1.price * $1.num) }
                return total + productTotal
            }
            return total
        }
    }
}


#Preview {
    CustomerCart()
        .environmentObject(FireStoreManager())
}
