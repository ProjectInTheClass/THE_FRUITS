//
//  Cart.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//

import SwiftUI

struct PriceSection: View {
    
    var orderAmount: Int = 16000
    var deliveryFee: Int = 3000
    
    var totalAmount: Int {
        orderAmount + deliveryFee
    }
    
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color("lightGray"))
            .frame(width: 360, height: 170)
            .overlay(
                VStack(){
                   Text("결제 금액")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    Divider()
                        .padding(.bottom, 10)
                    VStack(){
                        HStack {
                            Text("주문 금액")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Text("\(orderAmount) 원")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                        .padding(.bottom,5)
                        
                        HStack {
                            Text("배송비")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Text("\(deliveryFee) 원")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                        .padding(.bottom,5)
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
        )
    }
}

struct fetchData: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var cart: CartModel?
    @State private var orderprods : [OrderProdModel] = []

    var body: some View {
        VStack(spacing: 20) {
            // Customer 정보 표시
            if let customer = firestoreManager.customer {
                if customer.username.isEmpty {
                    Text("User data is loading...")
                } else {
                    Text("User Name: \(customer.name)")
                }
            } else {
                Text("Loading user data...")
            }
            // Cart 정보 표시
            if let cart = firestoreManager.cart {
                Text("Cart Brand ID: \(cart.brandid)")
            } else {
                Text("Loading cart data...")
            }
            
            // Orderprod 정보 출력
            if !orderprods.isEmpty {
                ForEach(orderprods, id: \.orderprodid) { orderprod in
                    ForEach(orderprod.products, id: \.productid) { product in
                        Text("Product ID: \(product.productid), Num: \(product.num)")
                    }
                }
            } else {
                Text("Loading order products...")
            }
        }
        .task {
            // Customer ID를 기반으로 Cart 데이터를 로드
            if let customer = firestoreManager.customer {
                //cart = await firestoreManager.fetchCart(userId: customer.customerid)
                await firestoreManager.fetchCart(userId: customer.customerid)
                // Orderprod 데이터를 가져옵니다
                if let fetchedOrderProds = await firestoreManager.fetchOrderProd() {
                    orderprods = fetchedOrderProds // 상태 업데이트
                }
                
            }
            
        }
    }
}



struct CustomerCart: View {
    var body: some View {
        NavigationStack {
            PriceSection()
                .padding(.bottom,20)
            fetchData()
            //CartData()
            CustomButton(
                title: "주문하기",
                background: Color("darkGreen"),
                foregroundColor: .white,
                width: 140,
                height: 33,
                size: 14,
                cornerRadius: 15,
                action: {
                    //submitUserInfo()
                    }
                )
            
            
            }
        }
    }




#Preview {
    CustomerCart()
        .environmentObject(FireStoreManager())
}
