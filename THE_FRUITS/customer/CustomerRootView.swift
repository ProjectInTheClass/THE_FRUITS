import SwiftUI

struct CustomerRootView: View {
    @Binding var selectedTab : Int

    @State private var isOnRootView=true
    @EnvironmentObject var firestoreManager: FireStoreManager // 공유 객체
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                
                Group{
                    if selectedTab==0{
                        CustomerHome()
                            .onAppear{isOnRootView=true}
                    }else if selectedTab==1{
                        CustomerWishList()
                            .onAppear{isOnRootView=true}
                    }else if selectedTab==2{
                        CustomerMyPage()
                            .onAppear{isOnRootView=true}
                    }
                }
            }
            Spacer()
            
            if isOnRootView{
                Divider()
                    .background(Color.gray)
                    .padding(.bottom,5)
                
                HStack(spacing: 30){
                    Spacer()
                    customTabButton(icon: "house", tabIndex: 0)
                    
                    Spacer()
                    customTabButton(icon: "heart", tabIndex: 1)
                    Spacer()
                    customTabButton(icon: "person.crop.circle", tabIndex: 2)
                    
                    Spacer(minLength: 20)
                }
                .frame(height:60)
                .cornerRadius(30)
            }
        }
        .onAppear{
            isOnRootView=true
            
        }
        .onDisappear{
            isOnRootView=false
        }
    }

    // 커스텀 탭 버튼 함수
    func customTabButton(icon: String, tabIndex: Int) -> some View {
        Button(action: {
            selectedTab = tabIndex
        }) {
            ZStack {
                Circle()
                    .fill(selectedTab == tabIndex ? Color("darkGreen") : .clear)
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .foregroundColor(selectedTab == tabIndex ? .white : Color("darkGreen"))
                    .font(.system(size: 24))
            }
            
        }
    }
}

//#Preview {
//    @Previewable @State var selectedTab = 0
//    CustomerRootView(selectedTab: $selectedTab)
//}


// Color 확장 추가 (Hex 코드를 처리하는 기능)
extension Color {
    init(hex: String) {
        let hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
