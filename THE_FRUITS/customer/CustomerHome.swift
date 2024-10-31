//
//  Home.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//

import SwiftUI

struct CustomerHome: View {
    
    @State private var searchText:String=""
    var body: some View {
        NavigationView{
            VStack{
                SearchBar(searchText: $searchText)
                    .padding(.top,45)
                    .padding(.bottom,3)
                
                HStack(){
                    CustomButton(title: "최신등록순",
                                 background: Color(UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)),
                                 foregroundColor:.black,
                                 width: 55,
                                 height:30,
                                 size:8.5,
                                 cornerRadius: 13,
                                 icon:Image(systemName:"arrow.up.arrow.down"),
                                 iconWidth:10,
                                 iconHeight:10
                    ){
                        print("정렬버튼 클릭!")
                    }
                    Spacer()
                }
                .padding(.leading,12)

                Spacer()//위로 슉 올리기
            }
 

        }
    }
}

#Preview {
    CustomerHome()
}
