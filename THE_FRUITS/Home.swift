//
//  Home.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//

import SwiftUI

struct Home: View {
    
    @State private var searchText:String=""
    var body: some View {
        NavigationView{
            VStack{
            
                SearchBar(searchText: $searchText)
                    .padding(.top,45)
                Spacer()//위로 슉 올리기
                
            }
//            .navigationTitle("홈")
        }
    }
}

#Preview {
    Home()
}
