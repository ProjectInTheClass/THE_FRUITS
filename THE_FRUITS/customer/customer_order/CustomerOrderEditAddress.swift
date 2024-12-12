import SwiftUI

struct CustomerOrderEditAddress: View {
    @Environment(\.dismiss) var dismiss
    @Binding var order: OrderModel? // 상위에서 관리되는 OrderModel
    @State private var userAddress: String = ""
    @State private var recipientName: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("주소 변경")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)

            Divider()
                .padding(.horizontal)

            VStack(spacing: 10) {
                CustomerInputBox(
                    inputText: $userAddress,
                    title: "주소",
                    placeholder: "주소를 입력하세요"
                )
                CustomerInputBox(
                    inputText: $recipientName,
                    title: "받으실 분",
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
                        if alertMessage == "주소가 변경되었습니다." {
                            dismiss() // 성공 시 화면 닫기
                        }
                    })
                )
            }
        }
        .padding(.top)
        .onAppear {
            if let order = order {
                userAddress = order.recaddress
                recipientName = order.recname
                phoneNumber = order.recphone
            }
        }
    }

    private func updateOrderDetails() {
        guard var order = order else { return }
        
        // OrderModel 값 업데이트
        order.recaddress = userAddress
        order.recname = recipientName
        order.recphone = phoneNumber
        self.order = order

        alertMessage = "주소가 변경되었습니다."
        showAlert = true
    }
}
