//
//  CustomerFAQ.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/7/24.
//

import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct CustomerFAQ: View {
    @State private var expandedItems: [UUID: Bool] = [:]
    
    let faqItems = [
        FAQItem(question: "주문을 취소하려면 어떻게 해야 하나요?", answer: "주문 취소는 가게로 직접 문의하세요."),
        FAQItem(question: "주문 후 시간이 한참 뒤에 취소되었다는 문자를 받았습니다. 왜 그런거죠?", answer: "상품 재고 부족으로 가게에서 주문을 취소할 수 있습니다.")
    ]
    
    var body: some View {
        List {
            ForEach(faqItems) { item in
                VStack(alignment: .leading) {
                    HStack {
//                        Text("\(faqItems.firstIndex(where: { $0.id == item.id })! + 1, specifier: "%02d")") // 질문 번호
//                        
                        Text(item.question)
                        
                        Spacer()
                        
                        Button(action: {
                            expandedItems[item.id]?.toggle()
                        }) {
                            Image(systemName: (expandedItems[item.id] ?? false) ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                        }
                    }
                    
                    if expandedItems[item.id] ?? false { // 열려 있는 경우에만 답변 표시
                                            Divider()
                                            Text(item.answer)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .padding(.top, 5)
                                        }
                }
                .padding(.vertical, 10)
                .onAppear {
                                    // 항목의 초기 상태 설정
                                    if expandedItems[item.id] == nil {
                                        expandedItems[item.id] = false
                                    }
                                }
            }
        }
        .listStyle(PlainListStyle())
    }
}


