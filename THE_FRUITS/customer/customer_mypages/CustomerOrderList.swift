//
//  CustomerOrderList.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//

import SwiftUI



struct CustomerOrderList: View {
    var body: some View {
        BackArrowButton(title: "주문 내역")
        VStack {
            Text("주문내역")
        }
        
    }
}

struct ProgressBarView: View {
    var state: String
    
    var body: some View {
        HStack(spacing: 4) {
            // 상태에 따라 막대 색상 설정
            ForEach(0..<4, id: \.self) { index in
                Rectangle()
                    .fill(index < greenBarCount() ? Color("darkGreen") : Color.white)
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
    // 녹색 막대의 개수를 결정하는 함수
    private func greenBarCount() -> Int {
        switch state {
        case "주문준비중":
            return 0;
        case "주문완료":
            return 1
        case "배송준비중":
            return 2
        case "배송중":
            return 3
        case "배송완료":
            return 4
        default:
            return 0
        }
    }
}
    

    
    
struct OrderCardView: View {
    var date: String
    var status: String
    var storeName: String
    var price: String

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            // 날짜와 상태 표시
            HStack() {
                Text(date)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(width: 360)
            .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("beige"))
                .frame(width: 360, height:120)
                .overlay(
                    VStack(spacing:10){
                        HStack{
                            Text(status)
                                .font(.system(size: 20))
                                .foregroundColor(Color("darkGreen"))
                                .padding(.top,5)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack{
                            ProgressBarView(state: status)
                        }
                        
                        HStack {
                            Text(storeName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                            Text(price)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.trailing,5)
                        }
                        .padding(.horizontal)
                        
                        // 주문 상세 버튼
                        HStack {
                            Spacer()
                            CustomButton(
                                title: "주문상세",
                                background: Color("darkGreen"),
                                foregroundColor: .white,
                                width: 75,
                                height:27,
                                size: 12,
                                cornerRadius: 20,
                                action: {
                                    // 주문하기 액션
                                }
                            )
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 10)
                    })
        }
    }
}

#Preview {
    //CustomerOrderList()
    OrderCardView(
        date: "2024.10.08",
        status: "배송준비중",
        storeName: "철수네 과일가게",
        price: "45,000원"
    )
}
