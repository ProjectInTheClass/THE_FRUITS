import SwiftUI

struct ChangeAddress: View {
    @State private var newAddress: String = ""
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    print("뒤로가기 버튼 클릭")
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
            
            Spacer()
        }
    }
    
    func submitAddress(){
        if newAddress.isEmpty {
            print("주소를 입력하세요")
        }
        else{
            print("\(newAddress)가 서버로 제출되었습니다")
        }
    }
}



#Preview {
    ChangeAddress()
}
