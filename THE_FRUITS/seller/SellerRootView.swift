//
//  RootView.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct SellerRootView: View {
    @Binding var selectedTab: Int  // 기본적으로 홈화면이 선택된 상태로 시작
    @State private var isOnRootView = true
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()  // 상단 화면을 채울 공간
                
                // 선택된 탭에 따라 다른 화면을 보여줌
                Group {
                    if selectedTab == 0 {
                        SellerHome()
                            .onAppear { isOnRootView = true }  // Reset when appearing
                    } else if selectedTab == 1 {
                        SellerOrder()
                            .onAppear { isOnRootView = true }
                    } else if selectedTab == 2 {
                        SellerMyPage()
                            .onAppear { isOnRootView = true }
                    }
                }
                
                Spacer()
                
                if isOnRootView {
                    Divider()  // 경계선을 추가하는 SwiftUI의 기본 뷰
                        .background(Color.gray)  // 경계선의 색상 설정
                        .padding(.bottom,5)
                    
                    // 하단 커스텀 네비게이션 바
                    HStack(spacing:30) {
                        Spacer()
                        
                        customTabButton(icon: "house", tabIndex: 0)
                        
                        Spacer()
                        
                        customTabButton(icon: "heart", tabIndex: 1)
                        
                        Spacer()
                        
                        customTabButton(icon: "person.crop.circle", tabIndex: 2)
                        
                        Spacer(minLength: 20)  // 바깥쪽 좌우에 간격 추가
                    }
                    .frame(height: 60)
                    .cornerRadius(30)  // 모서리 둥글게 처리 (옵션)
                }
            }
            .onAppear {
                isOnRootView = true
            }
            .onDisappear {
                isOnRootView = false
            }
        }
    }

    // 커스텀 탭 버튼 함수
    func customTabButton(icon: String, tabIndex: Int) -> some View {
        Button(action: {
            selectedTab = tabIndex
        }) {
            ZStack {
                Circle()
                    .fill(selectedTab == tabIndex ? Color(hex: "#1A321B") : .clear)
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .foregroundColor(selectedTab == tabIndex ? .white : Color(hex: "#1A321B"))
                    .font(.system(size: 24))
            }
            
        }
    }
}

#Preview {
    @Previewable @State var selectedTab = 0
    SellerRootView(selectedTab: $selectedTab)
}



// Color 확장 추가 (Hex 코드를 처리하는 기능)
/*extension Color {
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
*/
