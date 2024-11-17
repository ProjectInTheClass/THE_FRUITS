//
//  OnBoarding.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/13/24.
//

//
//  ContentView.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/13/24.
//

import SwiftUI

struct OnBoarding: View {
    @EnvironmentObject var firestoreManager: FireStoreManager // EnvironmentObject를 써서 같은 유저에 대해 데이터가 저장되고 공유되도록 한다
    
    var body: some View {

        NavigationStack{
            ZStack{
                Image("onBoardingImageOriginal")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer() // 위쪽 여백 추가
                        .frame(height: 450)
                        // 원하는 높이로 조정
                    Text("TheFruits")
                        .font(.custom("Magnolia Script", size: 63))
                        .foregroundStyle(.white)
                        .padding(.bottom,8)
                    NavigationLink(destination:Login(userType: "customer")){
                        Text("구매자로 시작하기")
                            .font(.custom("Pretendard-SemiBold", size: 18))
                            .frame(width:330,height:60)
                            .foregroundStyle(.white)
                            .background(Color(red: 26/255, green: 50/255, blue: 27/255)) // 색상 설정
                            .cornerRadius(40)
                    }
                    
                    NavigationLink(destination:Login(userType: "seller")){
                        Text("판매자로 시작하기")
                            .font(.custom("Pretendard-SemiBold", size: 18))      .frame(width:330,height:60)
                            .foregroundStyle(.black)
                            .background(Color(red: 233/255, green: 229/255, blue: 219/255)) // 두 번째 버튼 색상으로 변경
                            .cornerRadius(40)
                    }
                }

            }
        }
    }
}

#Preview {
    OnBoarding()
        .environmentObject(FireStoreManager())
}

