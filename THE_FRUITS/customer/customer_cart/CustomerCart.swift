//
//  Cart.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//

import SwiftUI
struct CartSummaryView: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @Binding var selectedTotal: Int // 선택된 총합을 바인딩으로 전달받음
    @State private var orderSummaries: [OrderSummary] = []
    @State private var isLoading = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("lightGray"))

            VStack(spacing: 10) {
                if isLoading {
                    Text("Loading cart details...")
                        .padding(5)
                } else {
                    ForEach(orderSummaries, id: \.orderprodid) { summary in
                        VStack {
                            HStack {
                                // 체크박스 UI
                                ZStack {
                                    Circle()
                                        .stroke(Color("darkGreen"), lineWidth: 1.5)
                                        .frame(width: 15, height: 15)
                                    
                                    if summary.selected {
                                        Circle()
                                            .fill(Color("darkGreen"))
                                            .frame(width: 10, height: 10)
                                    }
                                }
                                Spacer()
                            }

                            // 각 제품 출력
                            ForEach(summary.products, id: \.productName) { product in
                                HStack {
                                    HStack(spacing: 5) {
                                        Text(product.productName)
                                            .font(.system(size: 16, weight: .bold))
                                        Text("\(product.price)원")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    // 수량 조정 버튼
                                    HStack(spacing: 10) {
                                        var quantity: Int = product.num
                                        Button(action: {
                                            if quantity > 1 {
                                                quantity -= 1
                                                updateSelectedTotal()
                                            }
                                        }) {
                                            Text("-")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text("\(product.num)")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white)
                                        
                                        Button(action: {
                                            quantity += 1
                                            updateSelectedTotal()
                                        }) {
                                            Text("+")
                                                .font(.system(size: 15))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(width: 70, height: 30)
                                    .background(Color("darkGreen"))
                                    .cornerRadius(20)
                                }
                                .padding(.vertical, 5)
                            }

                            Divider()
                                .background(Color.gray)
                                .padding(.vertical, 5)
                        }
                        .padding(.horizontal, 10)
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
    
    

    // 선택된 제품의 총합 계산
    private func updateSelectedTotal() {
        selectedTotal = orderSummaries.reduce(0) { total, summary in
            if summary.selected {
                let productTotal = summary.products.reduce(0) { productTotal, product in
                    productTotal + (product.price * product.num)
                }
                return total + productTotal
            }
            return total
        }
    }
}



struct BrandButton: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var brandName: String? = nil

    var body: some View {
        VStack {
            if let brandName {
                CustomButton(
                    title: "< \(brandName)",
                    background: Color("darkGreen"),
                    foregroundColor: .white,
                    width: 80,
                    height: 33,
                    size: 14,
                    cornerRadius: 3,
                    action: {
                        //submitUserInfo()
                        }
                    )
            } else if firestoreManager.cart != nil {
                Text("Loading brand name...")
                    .onAppear {
                        Task {
                            brandName = await firestoreManager.getCartBrandName()
                        }
                    }
            } else {
                Text("Cart is loading...")
            }
        }
        .onAppear {
            Task {
                await firestoreManager.fetchCart()
            }
        }
    }
}

struct PriceSection: View {
    var orderAmount: Int // 주문 금액
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var delCost: Int? = nil // 배송비를 비동기로 업데이트
    var totalAmount: Int {
        orderAmount + (delCost ?? 0) // delCost가 nil이면 0으로 처리
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color("lightGray"))
            .frame(width: 360, height: 200)
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
    @State private var selectedTotal: Int = 0 // 선택된 총합 저장

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                BrandButton()
                CartSummaryView(selectedTotal: $selectedTotal) // 바인딩 전달
                PriceSection(orderAmount: selectedTotal) // 선택된 총합 전달
                CustomButton(
                    title: "주문하기",
                    background: Color("darkGreen"),
                    foregroundColor: .white,
                    width: 140,
                    height: 33,
                    size: 14,
                    cornerRadius: 15,
                    action: {
                        // 주문하기 액션
                    }
                )
            }
            .padding(.horizontal, 20)
        }
    }
}




#Preview {
    CustomerCart()
        .environmentObject(FireStoreManager())
}
