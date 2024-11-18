//
//  SellerOrder.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI

struct SellerOrder: View{
    @State private var sellerid = "troY2ZvhHxGfrSDCIggI"
    
    let brands = [
        Brand(name: "onbrix", logo: "onbrix"),
        Brand(name: "Orange", logo: "orange")
    ]
    
    var body: some View {
        NavigationView{
            VStack{
                Text("내 브랜드")
                    .font(.headline)
                    .padding(.leading)
                
                Spacer().frame(height: 50)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20){
                    ForEach(brands, id: \.name){ brand in
                        NavigationLink(destination: SellerBrandMainPage(brand: brand).navigationBarBackButtonHidden(true)){
                            VStack{
                                Image(brand.logo)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:150, height: 150)
                                    .cornerRadius(10)
                                
                                Text(brand.name)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Spacer()
            }
                .padding(.leading,12)

                Spacer()//위로 슉 올리기
        }
    }
}

#Preview {
    SellerOrder()
}
