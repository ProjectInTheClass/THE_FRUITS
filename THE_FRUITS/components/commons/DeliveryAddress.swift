//
//  DeliveryAddress.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/24/24.
//
import SwiftUI

struct DeliveryAddress: View {
    let title: String = "우리집"
    @EnvironmentObject var firestoreManager: FireStoreManager
    let onIconClick: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "house.fill")
                .foregroundColor(.black)
                .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 8) { // 모든 텍스트를 왼쪽 정렬
                Text(title) // 제목
                    .font(.custom("Pretendard-SemiBold", size: 16))
                    .foregroundColor(.black)
                
                Text(firestoreManager.customer?.address ?? "주소 없음") // 주소
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.black)
                
                Text("\(firestoreManager.customer?.name ?? "이름 없음") | \(firestoreManager.customer?.phone ?? "연락처 없음")") // 이름 및 연락처
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // 텍스트 전체를 왼쪽 정렬
            
            Button(action: {
                onIconClick()
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.black)
                    .padding(.top, 5)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30, height: 150)
        .background(Color(red: 169/255, green: 189/255, blue: 179/255)) // Custom background color
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    DeliveryAddress(onIconClick: {
        print("아이콘이 클릭되었습니다!")
    })
}
