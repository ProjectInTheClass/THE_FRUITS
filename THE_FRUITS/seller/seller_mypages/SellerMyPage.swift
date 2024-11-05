//
//  MyPage.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//

import SwiftUI

struct SellerProfileSection: View {
    let name: String = "김철수"
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 40, height: 180)
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "applelogo")
                            .resizable()
                            .frame(width: 33, height: 40)
                        
                        Text(name)
                            .font(.custom("Pretendard-SemiBold", size: 18))
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    Divider()
                    
                    VStack {
                        SellerProfileButton(
                            icon: "person.fill",
                            title: "내정보 설정",
                            action: {
                                print("내정보 설정 버튼 클릭됨")
                            }
                        )
                        
                        SellerDeliverySettingButton(
                            icon: "person.fill",
                            title: "배송지 설정",
                            destination: SellerDeliverySetting()
                        )
                    }
                }
            )
    }
}

struct SellerProfileButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20, height: 23)
                Text(title)
                    .font(.custom("Pretendard-SemiBold", size: 18))
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.leading, 25)
            .padding(.top, 5)
        }
        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
    }
}

struct SellerDeliverySettingButton<Destination: View>: View {
    let icon: String
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20, height: 23)
                Text(title)
                    .font(.custom("Pretendard-SemiBold", size: 18))
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.leading, 25)
            .padding(.top, 5)
        }
        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
    }
}

struct SellerMyPage: View {
    var body: some View {
        NavigationView {
            VStack {
                ProfileSection()
                Spacer()
            }
            .navigationTitle("마이페이지")
        }
    }
}

#Preview {
    SellerMyPage()
}
