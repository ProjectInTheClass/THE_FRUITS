//
//  Login.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/13/24.
//

import SwiftUI

struct Join: View {
    var body: some View {
        ZStack{
            Image("onBoardingImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer() // 위쪽 여백 추가
                    .frame(height: 450) // 원하는 높이로 조정


                Button( action:{
                    print("구매자로 시작하기")
                })
                {
                    Text("로그인")
                        .font(.custom("Pretendard-SemiBold", size: 18))
                        .frame(width:330,height:60)
                        .foregroundStyle(.white)
                        .background(Color(red: 26/255, green: 50/255, blue: 27/255)) // 색상 설정
                        .cornerRadius(40)
                }
                .padding(.bottom, 20) // 첫 번째 버튼과 두 번째 버튼 사이에 간격 추가
                Button(action:{
                    print("판매자로 시작하기")
                }){
                    Text("회원가입하기")
                        .font(.custom("Pretendard-SemiBold", size: 18))
                        .foregroundColor(Color(red: 26/255, green: 50/255, blue: 27/255)) // 글자색을 #1A321B로 설정
                                       

                }
    
    
            }
  
        
        }
    }
}

#Preview {
    Join()
}
