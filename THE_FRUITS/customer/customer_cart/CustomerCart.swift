//
//  Cart.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//

import SwiftUI

struct PriceSection: View {
    
    @EnvironmentObject var firestoreManager: FireStoreManager
    
    
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


struct CustomerCart: View {
    var body: some View {
        NavigationStack {
            PriceSection()
                .padding(.bottom,20)
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
}
