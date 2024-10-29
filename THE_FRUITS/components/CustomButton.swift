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
    var icon:Image?
    var iconWidth: CGFloat?  // 아이콘의 너비 (옵셔널)
    var iconHeight: CGFloat?  // 아이콘의 높이 (옵셔널)
    var action: () -> Void  // 클로져를 맨 밑에 위치 안시키면 오류오류남

    var body: some View {
        Button(action:action){
            HStack(spacing:1){
                if let icon = icon,let iconWidth = iconWidth,let iconHeight = iconHeight {  // 아이콘이 있을 경우에만 표시
                    icon
                        .resizable()
                        .frame(width: iconWidth, height: iconHeight)  // 아이콘 크기 설정
                        .foregroundColor(foregroundColor)  // 아이콘 색상 설정
                        .padding(.leading,13)  // 아이콘 오른쪽에 여백 추가
                }
                Text(title)
                    .font(.custom("Pretendard-SemiBold",size:size))
                    .frame(width:width,height:height)
                    .foregroundColor(foregroundColor)
                
            }
            .background(background != nil ? background : Color.clear)
            .cornerRadius(cornerRadius)
        }
    }
}

