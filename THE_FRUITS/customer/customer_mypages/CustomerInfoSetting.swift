//
//  CustomerInfoSetting.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/5/24.
//

import SwiftUI

struct CustomerInfoSetting: View {
    var body: some View {
        BackArrowButton(title: "내정보 설정")
        Spacer()
        
        // "주소" 텍스트를 왼쪽으로 정렬
        Text("주소")
            .padding(.top,10)
            .font(.custom("Pretendard-SemiBold", size: 16)) // 폰트 조정 가능
            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            .padding(.leading, 18) // 왼쪽에 패딩 추가
            .padding(.bottom,-10)
        
        // TextField의 높이를 외부 레이아웃을 통해 조정
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 50) // 텍스트 필드의 외부 높이를 조정
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

#Preview {
    CustomerInfoSetting()
}
