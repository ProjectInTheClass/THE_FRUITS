//
//  SellerOrder.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI

struct SellerOrder: View{
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var brands: [BrandModel] = []
    
    @State private var sellerid = "troY2ZvhHxGfrSDCIggI"
    
    /*let brands = [
     Brand(name: "onbrix", logo: "onbrix"),
     Brand(name: "Orange", logo: "orange")
     ]*/
    
    var body: some View {
        NavigationView{
            VStack{
                Text("내 브랜드")
                    .font(.headline)
                    .padding(.leading)
                
                Spacer().frame(height: 50)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20){
                    ForEach(brands, id: \.brandid){ brand in
                        NavigationLink(destination: SellerOrderList(brand: brand)){
                            VStack{
                                AsyncImage(url: URL(string: brand.logo)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(10)
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(10)
                                }
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
            .onAppear{
                loadBrands()
            }
            
            Spacer()//위로 슉 올리기
        }
    }
    
    func loadBrands() {
        Task {
            do {
                brands = try await firestoreManager.fetchBrands()
                print("Loaded \(brands.count) brands.")
            } catch {
                print("Error fetching brands: \(error)")
            }
        }
    }
}

#Preview {
    SellerOrder()
        .environmentObject(FireStoreManager())
}
