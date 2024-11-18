//
//  CartItemView.swift
//  THE_FRUITS
//
//  Created by 김진주 on 11/15/24.
//

import SwiftUI

struct CartItemView: View {
    @Binding var itemName: String // 상품 이름
    //@Binding var quantity: Int // 소비자가 선택한 수량을 바인딩으로 받습니다.
    @Binding var price: Int // 상품 가격
    @Binding var f_count:Int

    var body: some View {

        HStack() {
            Text(itemName)
                .font(.headline)
                .font(.custom("Pretendard-SemiBold", size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color("darkGreen"))
            Text("\(price)원")
                    .font(.subheadline)
            Text("\(f_count)개")
                    .font(.subheadline)

            CustomStepper(f_count:$f_count, width: 40, height: 20)
            Spacer()
                //CustomStepper(f_count: $quantity) // 수량 조정
            
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

