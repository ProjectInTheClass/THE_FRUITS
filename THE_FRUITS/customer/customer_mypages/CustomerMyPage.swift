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

struct ProfileSection: View {
    let name: String = "김철수"
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
                        
                        NavigationButton(
                        icon: "person.fill",
                        title: "내정보 설정",
                        destination: CustomerDeliverySetting()
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
                    Spacer()
                   NavigationButton(
                       icon: nil,
                       title: "주문내역", // 글자 길이에 따라 영역을 차지하는 넓이가 달라짐 -> 수정필요?
                       destination: CustomerOrderList()
                   )
                    Spacer()
                   Divider()
                       .frame(height: 50) // Divider 높이 조정
                    Spacer()
                   NavigationButton(
                       icon: nil,
                       title: "장바구니",
                       destination: CustomerCart()
                   )
                    Spacer()
               }
            )
    }
}

struct CustomerMyPage: View {
    var body: some View {
        NavigationStack {
            VStack() {
                ProfileSection()
                    .padding(.top, 40)
                    .padding(.bottom, 15)
                MenuSection()
                Spacer()
            }
        }
    }
}

#Preview {
    CustomerMyPage()
}





