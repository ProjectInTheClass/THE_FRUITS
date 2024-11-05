//
//  BackArrowButton.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//

import SwiftUI

struct BackArrowButton: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()//이전페이지로 네이게이트
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                        Spacer().frame(width: 15) // 아이콘과 텍스트 사이 간격
                        Text(title)
                            .font(.custom("Pretendard-SemiBold", size: 20))
                            .padding(.top,3)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 14)
            .padding(.bottom, 20)
            .background(Color.white)
        }
    }
}
