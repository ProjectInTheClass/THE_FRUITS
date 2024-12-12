//  MyPage.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/19/24.
//

import SwiftUI

struct SellerProfileSection: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var userName: String = ""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 30, height: 180)
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image("appleLogo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text(userName)
                            .font(.custom("Pretendard-SemiBold", size: 18))
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        Spacer()
                    }
                    .onAppear{
                        Task {
                            await loadSellerInfo()
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    Divider()
                    
                    VStack {
                        
                        NavigationButton(
                        icon: "person.fill",
                        title: "내정보 설정",
                        destination: SellerInfoSetting()
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                    }
                }
            )
    }
    
    private func loadSellerInfo() async {
        firestoreManager.fetchSeller()
        if let seller = firestoreManager.seller {
            userName = seller.name
        }
    }
}

struct SellerMenuSection: View {
    @State var selectedTab: Int = 1
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 30, height: 70)
            .overlay(
                HStack {
                    Spacer()
                   NavigationButton(
                       icon: nil,
                       title: "주문내역", // 글자 길이에 따라 영역을 차지하는 넓이가 달라짐 -> 수정필요?
                       destination: SellerRootView(selectedTab: $selectedTab)
                        .navigationBarBackButtonHidden(true)
                   )
                    Spacer()
               }
            )
    }
}

struct SellerMyPage: View {
    @State private var isLoggedIn: Bool = true
    var body: some View {
        if isLoggedIn {
            NavigationStack {
                VStack() {
                    SellerProfileSection()
                        .padding(.top, 40)
                        .padding(.bottom, 15)
                    SellerMenuSection()
                    LogoutButton{
                        isLoggedIn = false // 로그아웃 후 상태 업데이트
                    }
                    .padding(.top, 25)
                    Spacer()
                }
            }
            
        } else {
            OnBoarding() // 로그아웃 후 Onboarding 화면으로 전환
        }
    }
}


    
/*
#Preview {
    SellerMyPage()
}
*/




