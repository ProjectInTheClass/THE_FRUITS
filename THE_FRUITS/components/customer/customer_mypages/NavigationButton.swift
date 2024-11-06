//
//  NavigationButton.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {
    let icon: String?
    let title: String
    let destination: Destination
    
    
    var body: some View {
            NavigationLink(destination: destination) {
                HStack {
                    if let icon = icon { // icon이 nil이 아닐 경우에만 Image 표시
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 20, height: 23)
                            .padding(.leading, 20)
                            .padding(.trailing, 10)
                    }
                }
                Text(title)
                    .font(.custom("Pretendard-SemiBold", size: 18))
            }
            .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
    }
}
