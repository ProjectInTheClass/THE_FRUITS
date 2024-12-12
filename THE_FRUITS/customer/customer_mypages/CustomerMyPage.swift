//
//  MyPage.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//
//
//  MyPage.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//

import SwiftUI
import FirebaseAuth


struct ProfileSection: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
//    let name: String = "김철수"
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 30, height: 180)
            .overlay(
                VStack(alignment: .leading) {
                    HStack {
                        Image("appleLogo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text(firestoreManager.customer?.name ?? "이름 없음")
                            .font(.custom("Pretendard-SemiBold", size: 18))
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    
                    Divider()
                    
                    VStack() {
                        NavigationButton(
                        icon: "person.fill",
                        title: "내정보 설정",
                        destination: CustomerInfoSetting()
                        )
                        .padding(.top, 10)
                        
                        NavigationButton(
                        icon: "location.fill",
                        title: "배송지 설정",
                        destination: CustomerDeliverySetting()
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                    }
                }
            )
    }
}

struct MenuSection: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 30, height: 100)
            .overlay(
                HStack {
                    
                   NavigationButton(
                       icon: nil,
                       title: "주문내역", // 글자 길이에 따라 영역을 차지하는 넓이가 달라짐 -> 수정필요?
                       destination: CustomerOrderList()
                   )
                   .frame(maxWidth: .infinity,alignment: .center)
                    
                   Divider()
                       .frame(height: 50) // Divider 높이 조정
                    
                   NavigationButton(
                       icon: nil,
                       title: "장바구니",
                       destination: CustomerCart()
                   )
                   .frame(maxWidth: .infinity,alignment: .center)
                    
               }
            )
    }
}

struct ServiceSection : View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 30, height: 120)
            .overlay(
                VStack(){
                   NavigationButton(
                       icon:"headphones",
                       title: "자주 묻는 질문",
                       destination: CustomerFAQ()
                   )
                   .frame(maxWidth: .infinity,alignment: .leading)
                   .padding(.top,10)
                   .padding(.bottom, 10)
//                   NavigationButton(
//                       icon: "info.circle",
//                       title: "약관 및 정책",
//                       destination: CustomerLegalNotice()
//                   )
//                   .frame(maxWidth: .infinity,alignment: .leading)
//                   .padding(.top,10)
//                   .padding(.bottom, 10)
               }
                
            
        )
    }
}

struct LogoutButton: View {
    var onLogout: () -> Void
    @State private var showAlert: Bool = false 

    var body: some View {
        Button(action: {
            showAlert = true
        }) {
            Text("로그아웃")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color("darkGreen"))
                .cornerRadius(25)
        }
        .buttonStyle(PlainButtonStyle())
        
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("로그아웃"),
                message: Text("로그아웃 하시겠습니까?"),
                primaryButton: .destructive(Text("확인")) {
                    
                    do {
                        try Auth.auth().signOut()
                        print("로그아웃 성공")
                        onLogout()
                    } catch let signOutError as NSError {
                        print("로그아웃 실패: \(signOutError.localizedDescription)")
                    }
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}



struct CustomerMyPage: View {
    @State private var isLoggedIn: Bool = true // 로그인 상태 관리

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                VStack {
                    ProfileSection()
                        .padding(.top, 40)
                        .padding(.bottom, 15)
                    MenuSection()
                        .padding(.bottom, 15)
                    ServiceSection()
                    LogoutButton {
                        isLoggedIn = false // 로그아웃 후 상태 업데이트
                    }
                    .padding(.top, 25)
                    Spacer()
                }
            } else {
                OnBoarding() // 로그아웃 후 Onboarding 화면으로 전환
            }
        }
    }
}

#Preview {
    CustomerMyPage()
        .environmentObject(FireStoreManager())
}





