//
//  SellerInputBox.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 12/5/24.
//

import SwiftUI

struct SellerInputBox: View {
    @Binding var inputText: String
    
    let title : String
    let placeholder : String
    var isPwd: Bool = false
    
    var body: some View {
        // "주소" 텍스트를 왼쪽으로 정렬
        Text(title)
            .padding(.top,10)
            .font(.custom("Pretendard-SemiBold", size: 16)) // 폰트 조정 가능
            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            .padding(.leading, 17) // 왼쪽에 패딩 추가
            .padding(.bottom, -15)
        
        // TextField의 높이를 외부 레이아웃을 통해 조정
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 50) // 텍스트 필드의 외부 높이를 조정
            if isPwd {
               SecureField(placeholder, text: $inputText)
                    .padding(.leading, 10)
                    .frame(height: 50)
                    .textContentType(.password)
            }
            else {
               TextField(placeholder, text: $inputText)
                   .padding(.leading, 10)
                   .frame(height: 50)
                }
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}
