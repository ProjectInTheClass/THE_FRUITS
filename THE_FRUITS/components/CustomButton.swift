//
//  CustomButton.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//

import SwiftUI

struct CustomButton: View {
    var title: String  // 버튼의 제목
    var background: Color?  // 버튼의 배경색(nil이면 배경색 업슴)
    var foregroundColor:Color
    var width: CGFloat?  // 버튼의 너비
    var height: CGFloat?  // 버튼의 높이
    var size: CGFloat  // 버튼의 텍스트 크기
    var cornerRadius: CGFloat=0  // 버튼의 모서리 둥글기
    var action: () -> Void  // 버튼이 눌렸을 때 실행할 동작
    
    
    var body: some View {
        Button(action:action){
            Text(title)
                .font(.custom("Pretendard-SemiBold",size:size))
                .frame(width:width,height:height)
                .foregroundColor(foregroundColor)
            
        }
        .background(background != nil ? background : Color.clear)
        .cornerRadius(cornerRadius)

    }
}

