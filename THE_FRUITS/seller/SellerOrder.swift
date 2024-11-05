//
//  Order.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct SellerOrder: View {
    @State private var selectedStatus: String = "" // 초기값을 빈 문자열로 설정
    @State private var isFirstLoad: Bool = true // 첫 로드 여부를 확인하기 위한 변수
    let statuses = ["입금완료", "배송준비중", "배송중", "배송완료"]
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("주문번호: 232342-1")
                        .padding(8)
                        .background(Color("darkGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(4)
                    Spacer()
                    Text("2024.10.03")
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 9) {
                    // 첫 로드 시 "입금 미완료"를 표시하고, 이후에는 selectedStatus 표시
                    Text(isFirstLoad ? "입금 미완료" : selectedStatus)
                        .font(.headline)
                    HStack(spacing: 10) {
                        ForEach(statuses.indices, id: \.self) { index in
                            let status = statuses[index]
                            VStack {
                                if let selectedIndex = statuses.firstIndex(of: selectedStatus), selectedIndex != -1 {
                                    Rectangle()
                                        .frame(width: 70, height: 2.4)
                                        .foregroundColor(index <= selectedIndex ? Color("darkGreen") : Color.gray.opacity(0.3))
                                } else {
                                    Rectangle()
                                        .frame(width: 70, height: 2.4)
                                        .foregroundColor(Color.gray.opacity(0.3))
                                }
                                StatusButton(title: status, isSelected: selectedStatus == status) {
                                    selectedStatus = status
                                    isFirstLoad = false // 버튼을 클릭하면 첫 로드 상태를 false로 변경
                                }
                            }
                        }
                    }
                }
                
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .center)


                VStack(alignment: .leading,spacing:8) {
                        Text("주문상품")
                            .font(.headline)
                        Divider()
                        .background(Color("darkGreen"))
                        HStack {
                            Text("애플망고")
                            Spacer()
                            Text("8,000원 | 3개")
                        }
                        HStack {
                            Text("수박")
                            Spacer()
                            Text("10,000원 | 2개")
                        }
                        HStack {
                            Text("사과")
                            Spacer()
                            Text("1,000원 | 3개")
                        }
                        
                    }
                    .padding()
                    .frame(width:360,height:140)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                VStack(alignment: .leading,spacing:8) {
                    Text("주문자 정보")
                        .font(.headline)
                    Divider()
                    .background(Color("darkGreen"))
                    HStack {
                        Text("보내는 분")
                        Spacer()
                        Text("김철수")
                    }
                    HStack {
                        Text("휴대폰")
                        Spacer()
                        Text("010-0000-0000")
                    }
             
                }
                .padding()
                .frame(width:360)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                VStack(alignment: .leading,spacing:8) {
                    Text("배송지 정보")
                        .font(.headline)
                    Divider()
                    .background(Color("darkGreen"))
                    HStack {
                        Text("서울 동대문구 천호대로 257(청계푸르지오 시티 0동 0000호)")
                        Spacer()

                    }
                    HStack {
                        
                        Text("김철수 | 010-0000-0000")
                            .font(.custom("Pretendard-SemiBold", size: 13))

                    }
             
                }
                .padding()
                .frame(width:360)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .center)

                
                VStack(alignment: .leading,spacing: 8) {
                    Text("결제 금액")
                        .font(.headline)
                    Divider()
                    .background(Color("darkGreen"))
                    HStack {
                        Text("주문 금액")
                        Spacer()
                        Text("41,000 원")
                    }
                    HStack {
                        Text("배송비")
                        Spacer()
                        Text("3,000 원")
                    }
                    Divider()
                    .background(Color("darkGreen"))
                    HStack {
                        Text("최종결제금액")
                            .font(.headline)
                        Spacer()
                        Text("44,000원")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .frame(width:360)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            
        }
    }
}

struct StatusButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        VStack {
            Button(action: action) {
                Text(title)
                    .font(.custom("Pretendard-SemiBold", size: 16))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(isSelected ? Color("darkGreen") : Color("beige"))
                    .foregroundColor(isSelected ? Color.white : Color("darkGreen"))
                    .cornerRadius(5)
            }
        }
    }
}

#Preview {
    SellerOrder()
}
