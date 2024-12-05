//
//  CustomerOrder.swift
//  THE_FRUITS
//
//  Created by 박지은 on 12/4/24.
//

import SwiftUI

struct CustomerOrder: View {
    var orderList: [OrderSummary]
    
    var body: some View {
        
        VStack{
            Text("주문서")
                .font(.title)
                .padding()
            ForEach(orderList, id: \.orderprodid) { order in
                Text(order.orderprodid)
                    .padding(.vertical, 5)
            }
        }
    }
}

//#Preview {
//    CustomerOrder()
//}
