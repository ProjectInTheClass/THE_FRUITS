//
//  Home.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct SellerHome: View {
    @EnvironmentObject var firestoreManager: FireStoreManager // can fetch data about the sellerid stored in FirebaseManager shared with other screens
    //@State private var sellerid = "troY2ZvhHxGfrSDCIggI"
    
    @State private var brands: [BrandModel] = []
    
    var body: some View {
        NavigationView{
            VStack{
                Text("내 브랜드")
                    .font(.headline)
                    .padding(.leading)
                
                Spacer().frame(height: 50)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20){
                    ForEach(brands, id: \.brandid) { brand in                     NavigationLink(destination: SellerBrandMainPage(brand: brand)) {
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
                    
                    addButton
                }
                
                .task { // Fetch brands when the view appears
                    await loadBrands()
                }
                
                Spacer()
            }
            
            Spacer()//위로 슉 올리기
        }
        .padding(.leading, 12)
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
    SellerHome()
        .environmentObject(FireStoreManager())
}
