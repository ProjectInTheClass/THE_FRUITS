//
//  SellerBrandMainPage.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct SellerBrandMainPage: View{
    @State private var brand: Brand
    @Binding private var products: [ProductItem]
    
    
    @State private var showDeleteConfirmation = false
    @State private var selectedProduct: ProductItem? = nil
    
    let backgroundUrl: String = "https://example.com/background.jpg"
    let storeDesc: String = "Whatever Your Pick!"
    
    init(brand: Brand, products: Binding<[ProductItem]>) {
        _brand = State(initialValue: brand)
        _products = products
    }
    
    var body: some View{
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack(alignment: .bottomLeading) {
                        // 상위 배경 이미지
                        AsyncImage(url: URL(string: backgroundUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                                .frame(height: 200)
                        }
                        
                        // Store logo and details
                        HStack(alignment: .bottom) {
                            AsyncImage(url: URL(string: "\(brand.logo)")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 90, height: 90)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .padding(.bottom, 1)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                                    .frame(width: 90, height: 90)
                                    .cornerRadius(8)
                                    .padding(.bottom, 1)
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(brand.name)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text(storeDesc)
                                        .font(.custom("Pretendard-SemiBold", size: 16))
                                        .foregroundColor(Color("darkGreen"))
                                }
                                .padding(.bottom, -70)
                                Spacer()
                                
                                VStack {
                                    NavigationLink(destination: SellerBrandSetting()){
                                        RoundedRectangle(cornerRadius: 100)
                                            .stroke(Color.gray, lineWidth: 1)
                                            .frame(width: 120, height: 33)
                                            .overlay(
                                                Text("가게정보수정")
                                            )
                                    }
                                }
                                .padding(.top, 60)
                                .padding(.leading, 8)
                            }
                            .padding(.leading, 8)
                        }
                        .padding(.leading, -14)
                        .padding(.horizontal, 12)
                        .padding(.bottom, -60)
                    }
                    .padding(.bottom, 53)
                    
                    Divider()
                        .frame(height: 2)
                        .padding(.vertical, 8)
                    
                    /*BackArrowButton(title: "\(brand.name)")
                     //                Spacer()
                     VStack{
                     Image(brand.logo)
                     .resizable()
                     //                        .scaledToFit()
                     .frame(width: .infinity, height: 200)
                     //                        .cornerRadius(10)
                     HStack{
                     VStack(alignment: .leading, spacing: 4){
                     Text("\(brand.name)")
                     .font(.largeTitle)
                     .padding()
                     Text("가게 소개 글")
                     .font(.subheadline)
                     .foregroundColor(.black)
                     }
                     Spacer()
                     NavigationLink(destination: SellerBrandSetting().navigationBarBackButtonHidden(true)){
                     RoundedRectangle(cornerRadius: 100)
                     .stroke(Color.gray, lineWidth: 1)
                     .frame(width: 120, height: 33)
                     .overlay(
                     Text("가게정보수정")
                     )
                     }
                     }
                     }
                     .padding()
                     
                     Divider()
                     .padding(.vertical, 8)
                     */
                    
                    // 상품 아이템 넣기
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach($products, id: \.id) { $product in
                            VStack {
                                HStack(alignment: .top) {
                                    // Product Image
                                    AsyncImage(url: URL(string: product.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        Color.gray
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(8)
                                    }
                                    Spacer()
                                    
                                    VStack{
                                        HStack{
                                            Spacer()
                                            NavigationLink(destination: SellerEditProduct()) {
                                                Image(systemName: "pencil")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(.black)
                                            }
                                            .padding(.leading)
                                            
                                            Divider()
                                                .padding(.trailing)
                                                .frame(width: 1, height: 30)
                                                .background(.black)
                                            
                                            Button(action: {
                                                selectedProduct = product
                                                showDeleteConfirmation = true
                                            }) {
                                                Image(systemName: "trash")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        .padding(.trailing)
                                        
                                        
                                        HStack {
                                            
                                            
                                            // Product Title and Price
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(product.name)
                                                    .font(.headline)
                                                
                                                Text("\(product.price)원")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.white)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .alert("해당 과일을 삭제하시겠습니까?", isPresented: $showDeleteConfirmation) {
                            Button("예", role: .destructive) {
                                if let productToDelete = selectedProduct,
                                   let index = products.firstIndex(where: { $0.id == productToDelete.id }) {
                                    products.remove(at: index)
                                }
                            }
                            Button("아니오", role: .cancel) {}
                        }
                        
                        NavigationLink(destination: SellerAddProduct()){
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: .infinity, height: 50)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var sampleProducts: [ProductItem] = [
        ProductItem(id: "1", name: "프리미엄 고당도 애플망고", price: 7500, imageUrl: "https://example.com/mango.jpg"),
        ProductItem(id: "2", name: "골드 키위", price: 5500, imageUrl: "https://example.com/kiwi.jpg")
    ]
    let sampleBrand = Brand(name: "onbrix", logo: "onbrix")
    SellerBrandMainPage(brand: sampleBrand, products: $sampleProducts)
}
