import SwiftUI

struct CustomerOrderEditInfo: View {
    @Environment(\.dismiss) var dismiss
    @Binding var order: OrderModel? // 상위에서 관리되는 OrderModel
    @State private var customerName: String = ""
    @State private var phoneNumber: String = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("주문자 정보 변경")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                CustomerInputBox(
                    inputText: $customerName,
                    title: "보내는 분",
                    placeholder: "이름을 입력하세요"
                )
                CustomerInputBox(
                    inputText: $phoneNumber,
                    title: "휴대폰",
                    placeholder: "휴대폰 번호를 입력하세요"
                )
            }
            
            Spacer()
            
            Button(action: {
                updateOrderDetails()
            }) {
                Text("확인")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("darkGreen"))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("확인"), action: {
                        if alertMessage == "주문자 정보가 변경되었습니다." {
                            dismiss() // 성공 시 화면 닫기
                        }
                    })
                )
            }
        }
        .padding(.top)
        .onAppear {
            if let name = order?.customername {
                customerName = name
            }
            if let phone = order?.customerphone {
                phoneNumber = phone
            }
        }
    }

    /// `OrderModel`의 값을 업데이트하는 함수
    private func updateOrderDetails() {
        guard var order = order else { return }

        // `OrderModel` 값 업데이트
        order.customername = customerName
        order.customerphone = phoneNumber
        self.order = order

        // 알림 메시지 설정
        alertMessage = "주문자 정보가 변경되었습니다."
        showAlert = true
    }
}
