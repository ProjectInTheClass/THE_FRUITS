import SwiftUI



struct CustomerChangeAddress: View {
    @State private var newAddress: String = ""//이게 DB로 업데이트되어야 함
    @State private var showAlert = false // 모달창을 띄우기 위한 상태관리 변수
    @State private var alertMessage:String=""
//    @Environment(\.dismiss) var dismiss // 현재 뷰를 닫고 이전 뷰로 돌아가기 위한 dismiss 환경 변수
    @EnvironmentObject var firestoreManager: FireStoreManager
    
    var body: some View {
            VStack {
                
                //BackArrowButton(title: "주소 변경")
                
                // "주소" 텍스트를 왼쪽으로 정렬
                Text("주소")
                    .padding(.top,10)
                    .font(.custom("Pretendard-SemiBold", size: 16)) // 폰트 조정 가능
                    .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
                    .padding(.leading, 18) // 왼쪽에 패딩 추가
                    .padding(.bottom,-10)
                
                // TextField의 높이를 외부 레이아웃을 통해 조정
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(height: 50) // 텍스트 필드의 외부 높이를 조정
                    
                    TextField("수정할 주소를 입력하세요", text: $newAddress)
                        .padding(.leading, 10) // 텍스트 내부 패딩
                        .frame(height: 50) // 텍스트 필드 내부 높이
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                CustomButton(
                    title: "확인",
                    background: Color(red: 26/255, green: 50/255, blue: 27/255),
                    foregroundColor: .white,
                    width: 140,
                    height: 33,
                    size: 14,
                    cornerRadius: 15,
                    action: {
                        //버튼을 누르면 서버로 수정된 주소를 submit
                        submitAddress()
                    }
                )
                .alert(isPresented:$showAlert){
                    Alert(
                        title:Text("알림"),
                        message:Text(alertMessage),
                        dismissButton: .default(Text("확인"),action:{
                            print("Alert 닫힘")
                            showAlert=false
                        })
                    )
                }
                
                Spacer()
            }
        }


    func submitAddress() {
            if newAddress.isEmpty {
                alertMessage = "주소를 입력해주세요."
                showAlert = true
            } else {
                Task {
                    do {
                        guard let customerId = firestoreManager.customer?.customerid else {
                            alertMessage = "고객 정보를 불러올 수 없습니다."
                            showAlert = true
                            return
                        }
                        
                        // Firestore에 주소 업데이트
                        try await firestoreManager.updateCustomerAddress(customerId: customerId, address: newAddress)
                        
                        alertMessage = "주소가 성공적으로 수정되었습니다."
                        showAlert = true
                    } catch {
                        alertMessage = "주소 수정 중 오류가 발생했습니다: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
        }
    }

#Preview {

    CustomerChangeAddress()
}
