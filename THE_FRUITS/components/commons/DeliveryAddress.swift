//
//  DeliveryAddress.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/24/24.
//

import SwiftUI

struct DeliveryAddress: View {
    let title:String = "우리집"
    let address:String = "서울 동대문구 천호대로 257(청계푸르지오시티) 0동 0000호"
    let contactInfo:String = "김철수 | 010-0000-0000"

    let onIconClick:()->Void
    
    var body: some View {
        HStack(alignment:.top,spacing: 12){
            Image(systemName:"house.fill")
                .foregroundColor(.black)
                .padding(.top,5)
            VStack(alignment:.leading,spacing: 8){
                Text(title)//db에서 받아올거임
                    .font(.custom("Pretendard-SemiBold", size: 16))
                    .foregroundColor(.black)
                
                Text(address)//db에서 받아올거임
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading) // 자연스러운 줄바꿈
                
                Text(contactInfo)//db에서 받아올거임
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.black)
            }
            
            Button(action:{
                onIconClick()
            }){
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.black)
                    .padding(.top,5)
            }
        }
        
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30, height: 150)
        //.frame(maxWidth: .infinity)
        .background(Color(red: 169/255, green: 189/255, blue: 179/255)) // Custom background color
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    DeliveryAddress(onIconClick:{
        print("아이콘이 클리되었습니다!")
    })
}
