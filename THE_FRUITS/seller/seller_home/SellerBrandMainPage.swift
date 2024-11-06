//
//  SellerBrandMainPage.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct SellerBrandMainPage: View{
    @State private var brand: Brand
    
    init(brand: Brand) {
        _brand = State(initialValue: brand)
    }
    
    var body: some View{
        NavigationView{ //to be deleted
            VStack{
                BackArrowButton(title: "\(brand.name)")
                Spacer()
                Text("\(brand.name)")
                    .font(.largeTitle)
                    .padding()
                
                Image(brand.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}

#Preview {
    let sampleBrand = Brand(name: "onbrix", imageName: "onbrix")
    SellerBrandMainPage(brand: sampleBrand)
}
