import SwiftUI


struct CustomerDeliverySetting: View {
    // 네비게이션 상태를 관리하는 변수
    @State private var isNavigatingToChangeAddress = false
    
    var body: some View {
            VStack{
                //BackArrowButton(title: "배송지 설정")
                DeliveryAddress(onIconClick:{
                    isNavigatingToChangeAddress=true
                })
                .padding(.top,10)
                Spacer()
                
                    .navigationDestination(isPresented: $isNavigatingToChangeAddress){
                        CustomerChangeAddress()
                            //.navigationBarBackButtonHidden(true) // '뒤로가기' 버튼을 숨김
                    }
            }
        }
    }


#Preview {
    CustomerDeliverySetting()

}
