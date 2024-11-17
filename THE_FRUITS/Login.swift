//
//  Login.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/13/24.
//

import SwiftUI
import FirebaseAuth

enum Destination {
    case seller
    case customer
}

struct Login: View {
    @State private var user_id: String = ""
    @State private var password: String = ""
    @State private var loginStatus: Bool = false
    @State private var showLoginBox: Bool = false // 로그인 박스 표시 여부
    @State private var joinButtonClicked:Bool=false
    @State private var selectedTab: Int = 0
    @State private var navigationPath = NavigationPath() // path depending on seller or customer
    @State private var destination: Destination? = nil
    
    @EnvironmentObject var firestoreManager: FireStoreManager // StateObject 대신 EnvironmentObject를 써서 로그인 후에도 해당 유저에 대한 데이터가 저장되도록 한다
    
    var userType:String
        
    var body: some View {
        NavigationStack{
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
                                    
                                    SecureField("비밀번호 입력", text: $password) // 비밀번호 입력 시 user_id에서 password로 수정
                                        .padding(.leading, 10)
                                        .frame(width:300,height: 50)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    
                                    
                                    HStack {
                                        Spacer()
                                        
                                        CustomButton(title:"회원가입",foregroundColor: Color(red: 26/255, green: 50/255, blue: 27/255) ,size:14){
                                            print("회원가입 버튼 클릭")
                                            joinButtonClicked=true
                                            print("joinButtonClicked: \(joinButtonClicked)")
                                        }
                                        .padding(.top,10)
                                        
                                    }
                                    .frame(width: 250) //텍스트를 포함한 전체 너비 설정
                                    
                                    Spacer().frame(height: 20)
                                    
                                    /*CustomButton(title: "로그인",background:Color(red: 26/255, green: 50/255, blue: 27/255), foregroundColor:.white,width:300,height:60,size:14, cornerRadius:10){
                                        signInUser()
                                        print("로그인 클릭")
                                        print("user type: ", userType)
                                    }*/
                                    
                                    // 로그인 클릭 시 userType에 따라 화면 전환
                                    NavigationLink(destination: destinationView, tag: .seller, selection: $destination) { EmptyView() }
                                                        NavigationLink(destination: destinationView, tag: .customer, selection: $destination) { EmptyView() }

                                                        Button(action: {
                                                            signInUser()
                                                        }) {
                                                            Text("로그인")
                                                                .frame(maxWidth: .infinity)
                                                                .padding()
                                                                .background(Color(.darkGreen))
                                                                .foregroundColor(.white)
                                                                .cornerRadius(10)
                                                        }
                                                        .frame(width: 300, height: 60)
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
    @ViewBuilder
    private var destinationView: some View { // 유저에 따라 맞는 화면 전환
        if destination == .seller {
            SellerRootView(selectedTab: $selectedTab).navigationBarBackButtonHidden(true)
        } else if destination == .customer {
            CustomerRootView(selectedTab: $selectedTab).navigationBarBackButtonHidden(true)
        }
    }
    
    func signInUser() { // user credentials check
        Auth.auth().signIn(withEmail: user_id, password: password) { authResult, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                print("User logged in: \(user.uid)")
                firestoreManager.fetchUserData(userType: userType, userId: user.uid)
                
                // if seller, store the sellerid to fetch data about the corresponding seller in other screens
                if userType == "seller"{
                    firestoreManager.sellerid = user.uid
                }

                destination = userType == "seller" ? .seller : .customer
                loginStatus = true
            }
        }
    }
}

#Preview {
    Login(userType: "seller")
}
