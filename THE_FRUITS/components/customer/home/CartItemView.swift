//
//  CartItemView.swift
//  THE_FRUITS
//
//  Created by 김진주 on 11/15/24.
//

import SwiftUI

struct CartItemView: View {
    let itemName: String // 상품 이름
    let quantity: Int // 소비자가 선택한 수량을 바인딩으로 받습니다.
    let price: Int // 상품 가격

    var body: some View {

        HStack() {
            Text(itemName)
                .font(.headline)
                .font(.custom("Pretendard-SemiBold", size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color("darkGreen"))
            Text("\(price)원")
                    .font(.subheadline)
            Spacer()
                //CustomStepper(f_count: $quantity) // 수량 조정
            
            
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

