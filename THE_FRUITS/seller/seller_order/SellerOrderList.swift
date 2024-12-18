//
//  SellerOrderList.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI

struct SellerOrderList: View{
    @State private var brand: BrandModel
    @State private var orders: [OrderModel] = []
    @EnvironmentObject var firestoreManager: FireStoreManager
    
    init(brand: BrandModel) {
        _brand = State(initialValue: brand)
    }

    var body: some View{
        VStack(alignment: .leading){
            HStack(spacing: 16){
                Text("주문서 보기")
                    .font(.headline)
                Text("\(brand.name)")
                    .font(.subheadline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color("darkGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.leading)
            
            //Spacer()
            
            VStack(spacing: 3) {
                HStack(spacing: 16){
                    Text("주문번호")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("주문자 이름")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("주문상태")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(red: 0.925, green: 0.925, blue: 0.925)) // #ECECEC
                .font(.subheadline)
                
                Rectangle()
                    .fill(Color.gray) // Set to a darker color
                    .frame(height: 1) // Adjust thickness if needed
                
                ForEach(orders) { order in
                    NavigationLink(
                        destination: SellerOrderDetail(order: order)
                    ) {
                        HStack (spacing: 16){
                            Text(order.ordernum)
                                .foregroundColor(order.state == 0 ? .red : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(order.customername)
                                .foregroundColor(order.state == 0 ? .red : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(order.stateDescription ?? "Unknown") // need to change
                                .foregroundColor(order.state == 0 ? .red : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                    }
                }
            }
            .background(Color(red: 0.925, green: 0.925, blue: 0.925)) // #ECECEC
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .onAppear {
            loadOrders()
        }
    }
    
    func loadOrders() {
        Task {
            do {
                let fetchedOrders = try await firestoreManager.fetchOrders(for: brand.brandid)
                DispatchQueue.main.async {
                    self.orders = fetchedOrders.sorted(by: { $0.orderdate > $1.orderdate })
                    print("Loaded orders: \(fetchedOrders.count)")
                }
            } catch {
                print("Error fetching orders: \(error)")
            }
        }
    }
}

struct Order: Identifiable {
    let id = UUID()
    let number: String
    let name: String
    let status: String
}

let orderData = [
    Order(number: "234234-1", name: "김철수", status: "입금완료"),
    Order(number: "234234-2", name: "박은수", status: "입금 미완료"),
    Order(number: "234234-3", name: "김다운", status: "입금완료"),
    Order(number: "234234-4", name: "김하늘", status: "배송준비중"),
    Order(number: "234234-5", name: "김바다", status: "배송완료")
]

/*
#Preview {
    let sampleBrand = Brand(name: "onbrix", logo: "onbrix")
    SellerOrderList(brand: sampleBrand)
}
*/
