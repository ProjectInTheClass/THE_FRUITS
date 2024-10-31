//
//  Home.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct Brand{
    let name: String
    let imageName: String
}

struct SellerHome: View {
    @State private var sellerid = "troY2ZvhHxGfrSDCIggI"
    
    let brands = [
        Brand(name: "onbrix", imageName: "onbrix"),
        Brand(name: "Orange", imageName: "orange")
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
                        NavigationLink(destination: SellerBrandMainPage(brand: brand)){
                            VStack{
                                Image(brand.imageName)
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
                    
                    addButton
                }
                
                Spacer()
            }
                .padding(.leading,12)

                Spacer()//위로 슉 올리기
        }
            //.navigationTitle("내 브랜드")
    }
    // Add button view
    private var addButton: some View {
        NavigationLink(destination: SellerAddBrand()){
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .frame(width: 150, height: 150)
                .overlay(
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                )
        }
    }
}

#Preview {
    SellerHome()
}
