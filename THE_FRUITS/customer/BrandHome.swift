//
//  BrandHome.swift
//  THE_FRUITS
//
//  Created by 김진주 on 11/12/24.
//

import SwiftUI

struct ProductItem: Identifiable {
    let id: String
    let name: String
    let price: Int
    let imageUrl: String
}


struct BrandHome: View {
    let storeName:String
    let storeDesc:String="Whatever Your Pick!"
    let storeLikes:Int=27
    let products : [ProductItem] = [ProductItem(id:"1",name:"프리미엄 고당도 애플망고",price:7500,imageUrl: "https://example.com/mango.jpg"),
        ProductItem(id:"2",name:"골드 키위",price:5500,imageUrl: "https://example.com/kiwi.jpg")]
    let backgroundUrl: String = "https://example.com/background.jpg"
    let logoUrl: String = "https://example.com/store-logo.jpg"
    @State private var searchFruit:String=""
    
    var body: some View {
        VStack(alignment: .leading){
            SearchBar(searchText: $searchFruit)
            Spacer()
            ZStack(alignment: .bottomLeading){
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
                
                AsyncImage(url:URL(string:logoUrl)){
                    image in image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:80,height: 80)
                        .padding(12)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.bottom,-45)
                }placeholder: {
                    Color.gray.opacity(0.2)
                        .frame(width: 80,height:80)
                        .cornerRadius(8)
                        .padding(.bottom, -45)
                }
            }
            
            .padding(.bottom,40)
                VStack(alignment: .leading, spacing: 4){
                    Text(storeName)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(storeDesc)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    HStack(spacing:8){
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                        Text("\(storeLikes) Likes")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                }
            
            .padding(.bottom,16)
            
            Divider()
                .padding(.vertical,8)
            
            
            Text("상품 목록")
                .font(.headline)
                .padding(.bottom,8)
            
            ScrollView{
                VStack(spacing:16){
                    //상품 목록 렌더링
                    ForEach(products){ product in
                        HStack{
                            AsyncImage(url:URL(string:product.imageUrl)){ image in image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100,height:100)
                                    .cornerRadius(8)
                            } placeholder:{
                                Color.gray.opacity(0.2)
                                    .frame(width: 60, height: 80)
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading){
                                Text(product.name)
                                    .font(.headline)
                                Text("\(product.price)원")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                            }
                            Spacer()
                        }
                        .padding(.vertical,8)
                    }
                }
            }
            
        }
        //Text("\(storeName)")
        .padding()
        .navigationTitle(storeName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    BrandHome(storeName:"온브릭스")
}
