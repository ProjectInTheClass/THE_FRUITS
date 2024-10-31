import SwiftUI


struct CustomerDeliverySetting: View {
    // 네비게이션 상태를 관리하는 변수
    @State private var isNavigatingToChangeAddress = false
    
    var body: some View {
            VStack{
//                HStack{
//                    Button(action:{
//                        print("뒤로가기 버튼 클릭")
//                    }){
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.black)
//                    }
//                    Spacer().frame(width:10)//아이콘이랑 텍스트 사이 간격
//                    Text("배송지설정")
//                        .font(.custom("Pretendard-SemiBold", size: 18))
//                        .foregroundColor(.black)
//                    Spacer()
//                }
//                .padding(.top,10)//
//                .padding(.leading,14)//<배송지 설정 좌우
//                .padding(.bottom,10)//<배송지설정 상하
//                .background(Color.white)
//
//                Rectangle()
//                    .frame(height: 2.5) // 높이를 2로 설정하여 Divider 굵기 조정
//                    .foregroundColor(Color.gray) // 색상 변경 가능
//                    .padding(.horizontal,16)
                BackArrowButton(title: "배송지 설정")
                

                DeliveryAddress(onIconClick:{
                    isNavigatingToChangeAddress=true
                })
                .padding(.top,10)
                
                Spacer()

                .navigationDestination(isPresented: $isNavigatingToChangeAddress){
                        CustomerChangeAddress()

                            .navigationBarBackButtonHidden(true) // '뒤로가기' 버튼을 숨김
                    }
            }
        }

    }


#Preview {
    CustomerDeliverySetting()

}
