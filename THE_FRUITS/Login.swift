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
    @State private var showLoginBox: Bool = true // 로그인 박스 표시 여부
    @State private var joinButtonClicked: Bool = false
    @State private var selectedTab: Int = 0
    @State private var navigationPath = NavigationPath()
    @State private var destination: Destination? = nil
    @State private var keyboardOffset: CGFloat = 0 // 키보드에 맞춘 뷰 이동

    @EnvironmentObject var firestoreManager: FireStoreManager

    var userType: String

    var body: some View {
        NavigationStack {
            ZStack {
                // 배경 이미지
                Image("onBoardingImageOriginal")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    VStack {
                        // 타이틀 텍스트
                        Text("TheFruits")
                            .font(.custom("Magnolia Script", size: 63))
                            .foregroundStyle(.white)
                            .padding(.bottom, 10)
                        
                        // 로그인 박스
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 400, height: 300)
                            .shadow(radius: 10)
                            .overlay(
                                VStack {
                                    // 아이디 입력 필드
                                    TextField("아이디 입력", text: $user_id)
                                        .padding(.leading, 10)
                                        .frame(width: 300, height: 50)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    
                                    // 비밀번호 입력 필드
                                    SecureField("비밀번호 입력", text: $password)
                                        .padding(.leading, 10)
                                        .frame(width: 300, height: 50)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    
                                    HStack {
                                        Spacer()
                                        // 회원가입 버튼
                                        CustomButton(title: "회원가입", foregroundColor: Color(red:6/255, green: 50/255, blue: 27/255), size: 14) {
                                            joinButtonClicked = true
                                        }
                                        .padding(.top, 10)
                                    }
                                    .frame(width: 250)
                                    
                                    Spacer().frame(height: 20)
                                    // 로그인 클릭 시 userType에 따라 화면 전환
                                    NavigationLink(destination: destinationView, tag: .seller, selection: $destination) { EmptyView() }
                                    NavigationLink(destination: destinationView, tag: .customer, selection: $destination) { EmptyView() }
                                    
                                    // 로그인 버튼
                                    Button(action: { signInUser() }) {
                                        Text("로그인")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(.darkGreen))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .frame(width: 300, height: 60)
                                }
                                .padding()
                            )
                            .offset(y: showLoginBox ? -keyboardOffset-24 : UIScreen.main.bounds.height) // 키보드 감지 시 위로 이동
                            .animation(.easeInOut(duration: 0.3), value: showLoginBox) // 부드러운 애니메이션
                    }
                }
            }
        }
        .onAppear {
            setupKeyboardNotifications()
        }
        .onDisappear {
            removeKeyboardNotifications()
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

    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    // 키보드 오프셋 제한 추가
                    let screenHeight = UIScreen.main.bounds.height
                    keyboardOffset = min(keyboardFrame.height, screenHeight * 0.2) // 화면의 30%로 제한
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation {
               // showLoginBox = false // 키보드가 내려가면 박스를 화면 아래로 이동
            }
        }
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func signInUser() {
        // user credentials check
        Auth.auth().signIn(withEmail: user_id, password: password) { authResult, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                print("User logged in: \(user.uid)")
                firestoreManager.validateLogin(userType: userType, userId: user.uid) { isValid in
                    if isValid {
                        firestoreManager.fetchUserData(userType: userType, userId: user.uid)
                        // if seller, store the sellerid to fetch data about the corresponding seller in other screens
                        if userType == "seller"{
                            firestoreManager.sellerid = user.uid
                            destination = .seller
                        }
                        else if userType == "customer"{
                            firestoreManager.customerid = user.uid
                            destination = .customer
                        }
                        loginStatus = true
                    }
                    else {
                        print("Login failed. Invalid \(userType). Logging out.")
                        try? Auth.auth().signOut()
                    }
                    
                }
            }
        }
    }
}
