//
//  Login.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/13/24.
//

import SwiftUI

struct Login: View {
    @State private var user_id: String = ""
    @State private var password: String = ""
    @State private var loginStatus: Bool = false
    @State private var stayLoggedIn: Bool = false // 로그인 상태 유지 체크박스
    @State private var showLoginBox: Bool = false // 로그인 박스 표시 여부
    @State private var joinButtonClicked:Bool=false
    
    var userType:String
    
    var body: some View {
        ZStack {
            Image("onBoardingImageOriginal")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer() // 위쪽 여백 추가
                // 애니메이션 박스
                VStack {
                    Text("TheFruits")
                        .font(.custom("Magnolia Script", size: 63))
                        .foregroundStyle(.white)
                        .padding(.bottom,10)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 400, height: 300) // 박스 크기 설정
                        .shadow(radius: 10) // 그림자 추가
                        .overlay(
                            VStack {

                                
                                TextField("아이디 입력", text: $user_id)
                                    .padding(.leading, 10)
                                    .frame(width:300,height: 50)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                
                                TextField("비밀번호 입력", text: $password) // 비밀번호 입력 시 user_id에서 password로 수정
                                    .padding(.leading, 10)
                                    .frame(width:300,height: 50)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                
                                HStack {
                                    Spacer()
                                    Button(action:{
                                        print("회원가입 버튼 클릭")
                                        joinButtonClicked=true
                                        print("joinButtonClicked: \(joinButtonClicked)")
                                    }){
                                        Text("회원가입")
                                    }
                                    .padding(.top,10)
                                        .font(.custom("Pretendard-SemiBold", size: 14))
                                        .foregroundColor(.black) // 글자색을 검정색으로 설정
                                }
                                .frame(width: 250) //텍스트를 포함한 전체 너비 설정
            
                                Spacer().frame(height: 20)
                                Button(action: {
                                    //print("로그인 클릭")
                                    print(userType)
                                }) {
                                    Text("로그인")
                                        .font(.custom("Pretendard-SemiBold", size: 18))
                                        .frame(width: 300, height: 60)
                                        .foregroundColor(.white) // 텍스트 색상을 흰색으로 설정
                                        .background(Color(red: 26/255, green: 50/255, blue: 27/255)) // 색상 설정
                                        .cornerRadius(10)
                                }
                            }
                            .padding() // 내부 여백 추가
                        )
                        .offset(y: showLoginBox ? 0 : UIScreen.main.bounds.height) // 화면 아래로 시작
                        .animation(.spring(), value: showLoginBox) // 애니메이션 추가
                }
                .onAppear {
                    // 로그인 박스 표시 애니메이션 시작
                    showLoginBox = true
                }
            }
        }
    }
}

#Preview {
    Login(userType: "customer")
}
