import SwiftUI

struct CustomerOrderEditAddress: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @Environment(\.dismiss) var dismiss 
    var order: OrderModel?
    @State private var userAddress: String = ""
    @State private var recipientName: String = ""
    @State private var phoneNumber: String = ""

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
                Task {
                    do {
                        
                        try await firestoreManager.updateOrderAddress(
                            orderId: order?.orderid ?? "",
                            newAddress: userAddress,
                            newName: recipientName,
                            newPhone: phoneNumber
                        )
                        print("주소 정보가 성공적으로 업데이트되었습니다.")
                        
                        dismiss()
                    } catch {
                        print("주소 정보 업데이트 중 에러 발생: \(error.localizedDescription)")
                    }
                }
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
        }
        .padding(.top)
        .onAppear {
            
            if let address = order?.recaddress {
                userAddress = address
            }
            if let name = order?.recname {
                recipientName = name
            }
            if let phone = order?.recphone {
                phoneNumber = phone
            }
        }
    }
}
