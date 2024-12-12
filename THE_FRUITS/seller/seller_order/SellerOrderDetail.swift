//
//  Order.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI
import FirebaseFirestore

struct SellerOrderDetail: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State var order: OrderModel
    @State private var brands: [BrandModel] = []
    @State private var orderSummaries: [OrderSummary] = []
    
    @State private var selectedStatus: String = "" // 초기값을 빈 문자열로 설정
    @State private var isFirstLoad: Bool = true // 첫 로드 여부를 확인하기 위한 변수
    @State private var showModal :Bool=false
    @State private var trakingNumber:String=""
    @State private var deliveryCompany:String = ""
    let statuses = ["주문완료", "배송준비중", "배송중", "배송완료"]
    var body: some View {
        ScrollView{
            ZStack{
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("주문번호: \(order.ordernum)")
                                .padding(8)
                                .background(Color("darkGreen"))
                                .foregroundColor(Color.white)
                                .cornerRadius(4)
                            Spacer()
                            Text(order.orderdate)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 9) {
                            // 첫 로드 시 "입금 미완료"를 표시하고, 이후에는 selectedStatus 표시
                            Text(isFirstLoad ? "주문확인중" : selectedStatus)
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
                                            if status=="배송중" && selectedStatus != "배송중"{
                                                showModal = true
                                            }
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
                        
                        
                        VStack(alignment: .leading,spacing:8) {//db에서 받을 떄는 배열로 받아서 반복 렌더링.
                            Text("주문상품")
                                .font(.headline)
                            Divider()
                                .background(Color("darkGreen"))
                            
                            ForEach(orderSummaries, id: \.orderprodid) { orderSummary in
                                ForEach(orderSummary.products, id: \.productid) { product in
                                    HStack {
                                        Text(product.productName)
                                        Spacer()
                                        Text("\(product.price)원 | \(product.num)개")
                                    }
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(width:360)
                        
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
                                Text(order.customername)
                            }
                            HStack {
                                Text("휴대폰")
                                Spacer()
                                Text(order.customerphone)
                            }
                            
                        }
                        .padding()
                        .frame(width:360)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        /*VStack(alignment: .leading,spacing:8) {
                            Text("배송지 정보")
                                .font(.headline)
                            Divider()
                                .background(Color("darkGreen"))
                            Text(order.recaddress)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text("\(order.recname) | \(order.recphone)")
                                    .font(.custom("Pretendard-SemiBold", size: 13))
                            }
                        }
                        .padding()
                        .frame(width:360)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .center)*/
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 360)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("배송지 정보")
                                    .font(.headline)
                                
                                Divider()
                                    .background(Color("darkGreen"))
                                
                                Text(order.recaddress)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true) // Allow multiline wrapping
                                
                                HStack {
                                    Text("\(order.recname) | \(order.recphone)")
                                        .font(.custom("Pretendard-SemiBold", size: 13))
                                }
                            }
                            .padding()
                            .frame(width: 360, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        VStack(alignment: .leading,spacing: 8) {
                            Text("결제 금액")
                                .font(.headline)
                            Divider()
                                .background(Color("darkGreen"))
                            HStack {
                                Text("주문 금액")
                                Spacer()
                                Text("\(order.totalprice) 원")
                            }
                            HStack {
                                Text("배송비")
                                Spacer()
                                Text("\(order.delcost) 원")
                            }
                            Divider()
                                .background(Color("darkGreen"))
                            HStack {
                                Text("최종결제금액")
                                    .font(.headline)
                                Spacer()
                                let finalprice = order.totalprice + order.delcost
                                Text("\(finalprice)원")
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
                if showModal {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    DeliveryInputModal(showModal: $showModal,trackingNumber: $trakingNumber, deliveryCompany: $deliveryCompany, orderId: order.orderid)
                        .transition(.scale)
                }
            }
            
        }
        .onAppear {
            selectedStatus = order.stateDescription // Load the initial state from order
            Task{
                do{
                    orderSummaries = try await firestoreManager.fetchOrderProdDetails(order: order)
                }
                catch {
                    print("Error fetching order products: \(error)")
                }
            }
        }
        .onDisappear {
            if selectedStatus != order.stateDescription {
                updateOrderState() // Update Firestore if the status has changed
            }
        }
    }
    
    private func updateOrderState() {
        var state: Int = 0
        switch (selectedStatus) {
        case "주문완료": state = 1
        case "배송준비중": state = 2
        case "배송중": state = 3
        case "배송완료": state = 4
        default:
            state = 0
        }
        
        let db = Firestore.firestore()
        db.collection("order")
            .document(order.orderid) // Assuming ordernum is the unique document ID
            .updateData(["state": state]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Order state successfully updated to \(selectedStatus)")
                }
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

struct DeliveryInputModal: View{
    @Binding var showModal:Bool
    @Binding var trackingNumber : String
    @Binding var deliveryCompany : String
    var orderId: String
    
    var body:some View{
        VStack(spacing: 20){
            Text("택배사 및 송장번호를 입력해주세요")
                .font(.headline)
            
            TextField("택배사", text: $deliveryCompany)
                .font(.custom("Pretendard-SemiBold", size: 13))
                .padding()
            
            TextField("송장번호", text: $trackingNumber)
                .font(.custom("Pretendard-SemiBold", size: 13))
                .padding()
            
            Button(action:{
                saveTrackingNumber()
            }){
                Text("확인")
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(Color("lightGray"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
        .frame(width: 320, height: 280)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private func saveTrackingNumber() {
        let db = Firestore.firestore()
        db.collection("order")
            .document(orderId) // Use the order ID to find the correct document
            .updateData(["delnum": trackingNumber, "delname": deliveryCompany]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("입력된 송장번호: \(trackingNumber)")
                    showModal = false // Close the modal on success
                }
            }
    }
}

/*
#Preview {
    SellerOrderDetail(orderNumber: "1", customerName: "홍바다")
}
*/
