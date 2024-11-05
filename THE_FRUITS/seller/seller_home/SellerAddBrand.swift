//
//  SellerAddBrand.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct SellerAddBrand: View{
    var body: some View{
        NavigationView{
            VStack{
                Text("사업자 등록증이 있으신가요?")
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer().frame(height: 30)
                
                NavigationLink(destination: SellerInsertBusinessNum()){
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.black)
                        .frame(width: 350, height: 60)
                        .overlay(
                            Text("예")
                                .foregroundColor(.white)
                        )
                }
                
                Spacer().frame(height: 20)
                
                NavigationLink(destination: SellerTutorial()){
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 350, height: 60)
                        .overlay(
                            Text("아니오")
                                .foregroundColor(.black)
                        )
                }
            }
        }
    }
}

struct SellerInsertBusinessNum: View{
    @State private var businessNumber: String = ""
    
    var body: some View{
        NavigationView{
            VStack{
                Text("사업자 등록번호를 입력해주세요!")
                    .font(.system(size: 25))
                    .bold()
                    .padding()
                
                HStack{
                    TextField("사업자 등록번호", text: $businessNumber)
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.gray, lineWidth: 1) // Border for the rounded rectangle
                        )
                        //.padding() // Padding around the TextField
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    NavigationLink(destination: SellerHome()) {
                        Image(systemName: "arrow.right") // Arrow icon
                            .font(.title2) // Adjust size as needed
                            .foregroundColor(.black) // Color of the icon
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    SellerAddBrand()
}
