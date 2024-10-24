//
//  DeliveryAddress.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/24/24.
//

import SwiftUI

struct DeliveryAddress: View {
    
    var body: some View {
        HStack(alignment:.top,spacing: 12){
            Image(systemName:"house.fill")
                .foregroundColor(.black)
                .padding(.top,5)
            VStack(alignment:.leading,spacing: 8){
                Text("우리집")//db에서 받아올거임
                    .font(.custom("Pretendard-SemiBold", size: 16))
                    .foregroundColor(.black)
                
                Text("서울 동대문구 천호대로 257(청계푸르지오 시티)\n0동 0000호")//db에서 받아올거임
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.black)
               
                Text("김철수 | 010-0000-0000")//db에서 받아올거임
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Image(systemName: "paperplane.fill")
                .foregroundColor(.black)
                .padding(.top,5)
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    DeliveryAddress()
}
