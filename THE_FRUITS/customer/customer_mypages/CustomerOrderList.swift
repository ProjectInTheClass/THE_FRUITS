//
//  CustomerOrderList.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//
import SwiftUI
struct CustomerOrderList: View {
    @State private var orders: [(OrderModel, [OrderSummary], BrandModel)] = []
    @State private var isLoading: Bool = true
    @State private var showModal: Bool = false
    @State private var selectedDeliveryInfo: String = ""
    @State private var selectedDeliveryCompany: String = ""
    @EnvironmentObject var firestoreManager: FireStoreManager

    var body: some View {
        ZStack {
            VStack {
                if isLoading {
                    ProgressView("주문 내역 불러오는 중...")
                        .padding()
                } else if orders.isEmpty {
                    Text("주문 내역이 없습니다.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(orders.reversed(), id: \.0.orderid) { orderData in
                                let (order, summaries, brand) = orderData
                                OrderCardView(
                                    date: order.orderdate,
                                    status: statusText(for: order.state),
                                    storeName: brand.name,
                                    price: "\(formattedPrice(order.totalprice + order.delcost))원",
                                    orderList: summaries,
                                    order: order,
                                    showModal: $showModal,
                                    selectedDeliveryInfo: $selectedDeliveryInfo,
                                    selectedDeliveryCompany: $selectedDeliveryCompany
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            // 모달 표시
            if showModal {
                DeliveryInfoModal(
                    deliveryInfo: selectedDeliveryInfo,
                    deliveryCompany: selectedDeliveryCompany,
                    isPresented: $showModal
                )
            }
        }
        .onAppear {
            Task {
                await loadOrders()
            }
        }
    }

    private func loadOrders() async {
        isLoading = true
        do {
            let orderIds = try await firestoreManager.fetchOrders()

            guard !orderIds.isEmpty else {
                print("No orders found for customer.")
                isLoading = false
                return
            }

            var fetchedOrders: [(OrderModel, [OrderSummary], BrandModel)] = []

            for orderId in orderIds {
                let (order, summaries, brand) = try await firestoreManager.fetchOrder(orderId: orderId)
                fetchedOrders.append((order, summaries, brand))
            }

            orders = fetchedOrders
        } catch {
            print("Error fetching orders: \(error.localizedDescription)")
        }
        isLoading = false
    }

    private func statusText(for state: Int) -> String {
        switch state {
        case 0: return "주문확인중"
        case 1: return "주문완료"
        case 2: return "배송준비중"
        case 3: return "배송중"
        case 4: return "배송완료"
        default: return "알 수 없음"
        }
    }

    private func formattedPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? "0"
    }
}

struct OrderCardView: View {
    var date: String
    var status: String
    var storeName: String
    var price: String
    var orderList: [OrderSummary] // 주문 상품 목록
    var order: OrderModel?

    @Binding var showModal: Bool // 모달 표시 여부
    @Binding var selectedDeliveryInfo: String // 선택된 배송 정보
    @Binding var selectedDeliveryCompany: String // 선택된 택배 회사

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Text(date)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
                if status == "배송중" || status == "배송완료" {
                    Button(action: {
                        selectedDeliveryInfo = order?.delnum ?? "정보 없음"
                        selectedDeliveryCompany = order?.delname ?? "정보 없음"
                        showModal = true
                    }) {
                        HStack(spacing: 4) {
                            Text(status)
                                .foregroundColor(Color("darkGreen"))
                                .font(.system(size: 16, weight: .bold))
                                
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("darkGreen"))
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                }
            }
            //.frame(width: 360)
            .padding(.horizontal)

            RoundedRectangle(cornerRadius: 8)
                .fill(Color("beige"))
                //.frame(width: 360, height: 120)
                .frame(maxWidth: UIScreen.main.bounds.width - 48)
                .frame(height: 120)
                .overlay(
                    VStack(spacing: 10) {
                        HStack {
                            Text(status)
                                .font(.system(size: 18))
                                .foregroundColor(Color("darkGreen"))
                                .padding(.top, 15)
                            Spacer()
                        }
                        .padding(.horizontal)

                        HStack {
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
                                .padding(.trailing, 5)
                        }
                        .padding(.horizontal)

                        HStack {
                            Spacer()
                            NavigationLink(
                                destination: CustomerReceipt(orderList: orderList, order: order)
                            ) {
                                Text("주문상세")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 75, height: 27)
                                    .background(Color("darkGreen"))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 15)
                    }
                )
        }
        //.frame(maxWidth: UIScreen.main.bounds.width - 48)
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

    private func greenBarCount() -> Int {
        switch state {
        case "주문준비중":
            return 0
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
struct DeliveryInfoModal: View {
    var deliveryInfo: String
    var deliveryCompany: String
    @Binding var isPresented: Bool
    @State private var showAlert: Bool = false
    
    var body: some View {
        if isPresented {
            ZStack {
                
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
                
                // 모달 내용
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("배송 정보")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(deliveryCompany) // 택배회사 정보
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        
                        HStack {
                            Text(deliveryInfo) // 배송 번호
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                UIPasteboard.general.string = deliveryInfo // 클립보드에 복사
                                showAlert = true // 알림 표시
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.white)
                            }
                            .alert(isPresented: $showAlert) { // 알림 정의
                                Alert(
                                    title: Text("복사 완료"),
                                    message: Text("배송 번호가 복사되었습니다!"),
                                    dismissButton: .default(Text("확인"))
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color("darkGreen")) // 카드 배경색
                    .cornerRadius(8)
                }
                .padding()
                //.frame(width: 300) // 고정된 너비
                .frame(maxWidth: UIScreen.main.bounds.width - 48)
                .background(Color("darkGreen")) // 전체 배경색
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    CustomerOrderList()
}
