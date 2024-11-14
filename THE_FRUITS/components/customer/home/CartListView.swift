//
//  CartListView.swift
//  THE_FRUITS
//
//  Created by 김진주 on 11/15/24.
//

import SwiftUI

// 장바구니 드롭업 뷰
struct CartListView: View {
    @StateObject private var products = ObservableProducts()
    var body: some View {
        VStack {
            Text("장바구니")
                .font(.title)
                .padding()

            // 장바구니 아이템 목록
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(products.items){ item in
                        CartItemView(itemName: item.name, quantity: item.f_count, price: item.price)
                        
                    }
                }
            }
            HStack {
                Button(action: {
                    // 구매하기 기능 추가
                }) {
                    Text("바로 구매하기")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .presentationDetents([.fraction(0.4), .large]) // 드롭업 높이 설정
    }
}
#Preview {
    CartListView()
}
