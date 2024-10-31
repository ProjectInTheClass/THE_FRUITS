import SwiftUI

struct ChangeAddress: View {
    @State private var newAddress: String = ""//이게 DB로 업데이트되어야 함
    @State private var showAlert = false // 모달창을 띄우기 위한 상태관리 변수
    @State private var alertMessage:String=""
    @Environment(\.dismiss) var dismiss // 현재 뷰를 닫고 이전 뷰로 돌아가기 위한 dismiss 환경 변수
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    print("뒤로가기 버튼 클릭")
                    dismiss()//이전페이지로 네이게이트
                    print(dismiss)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer().frame(width: 10) // 아이콘과 텍스트 사이 간격
                Text("주소변경")
                    .font(.custom("Pretendard-SemiBold", size: 18))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 14) // 배송지 설정 좌우
            .padding(.bottom, 10) // 배송지 설정 상하
            .background(Color.white)
            
            Rectangle()
                .frame(height: 2.5) // 높이를 2로 설정하여 Divider 굵기 조정
                .foregroundColor(Color.gray) // 색상 변경 가능
                .padding(.horizontal, 16)
                .padding(.top, 10)
            
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

    
    func submitAddress(){
        if newAddress.isEmpty {
            print("주소를 입력하세요")
            alertMessage = "주소를 입력해주세요"
        }
        else{
            alertMessage = "수정되었습니다."
            //제출되면 '수정되었습니다' 모달창뜨고
            //DeliverySetting 페이지로 가기(그럼 업데이트된 주소가 되어
            //만약에 모달창에서 확인을 누르면 다시 DeliversySetting으로 가는 게 자연스럽지 않을까,,
            //new Address가 DeliverySetting으로 보내져야 한다.
        }
        showAlert=true
    }
}

#Preview {
    ChangeAddress()
}
