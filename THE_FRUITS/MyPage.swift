//
//  MyPage.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//

import SwiftUI

struct MyPage: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("마이페이지 화면")
            }
            .navigationTitle("마이페이지")
        }
    }
}

#Preview {
    MyPage()
}
