//
//  Home.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct Brand{ // should be defined in other file
    let name: String
    let logo: String
}

struct SellerHome: View {
    @EnvironmentObject var firestoreManager: FireStoreManager // can fetch data about the sellerid stored in FirebaseManager shared with other screens
    //@State private var sellerid = "troY2ZvhHxGfrSDCIggI"
    
    @State private var sampleProducts = [
        ProductItem(id: "1", name: "프리미엄 고당도 애플망고", price: 7500, imageUrl: "https://example.com/mango.jpg"),
        ProductItem(id: "2", name: "골드 키위", price: 5500, imageUrl: "https://example.com/kiwi.jpg")
    ]
    
    let brand = [ // to be deleted
        Brand(name: "onbrix", logo: "onbrix"),
        Brand(name: "Orange", logo: "orange")
    ]
    
    @State private var brands: [Brand] = [] // to be deleted
    
    var body: some View {
        NavigationView{
            VStack{
                Text("내 브랜드")
                    .font(.headline)
                    .padding(.leading)
                
                Spacer().frame(height: 50)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20){
                    ForEach(firestoreManager.brands, id: \.name){ brand in
                        NavigationLink(destination: SellerBrandMainPage(brand: brand, products: $sampleProducts)){
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
                    
                    addButton
                }
                
                Spacer()
            }
            .padding(.leading,12)
            .onAppear{
                firestoreManager.fetchBrands()
            }
            
            Spacer()//위로 슉 올리기
        }
    }
    // Add button view
    private var addButton: some View {
        NavigationLink(destination: SellerAddBrand().navigationBarBackButtonHidden(true)){
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
        .environmentObject(FireStoreManager())
}
