//
//  SellerEditProduct.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI

// should contain already uploaded info
struct SellerEditProduct: View{
    @State private var productName: String = ""
    @State private var productImage: String = ""
    @State private var productInfo: String = ""
    @State private var productPrice: String = ""
    @State private var productType: String = ""
    
    @State private var selectedTab = 0
    
    var body: some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // product name
                Text("상품 이름")
                HStack {
                    TextField("상품 입력", text: $productName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                    Button(action: {
                        checkProductNameRedundancy() // check name's redundancy
                    }) {
                        Text("중복 확인")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color("darkGreen"))
                            .cornerRadius(8)
                    }
                }
                
                // product image
                VStack {
                    Text("상품 이미지")
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }
                
                // product info
                VStack(alignment: .leading) {
                    Text("상품 소개")
                    TextField("상품을 소개해주세요!", text: $productInfo)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                
                InputField(title: "상품 가격", placeholder: "상품 가격을 입력해주세요.", text: $productPrice)
                InputField(title: "상품 종류", placeholder: "상품 종류를 입력해주세요.", text: $productType)
                
                Spacer()
                
                NavigationLink(destination: SellerRootView(selectedTab: $selectedTab).navigationBarBackButtonHidden(true)) {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    func checkProductNameRedundancy() {
        // checking for brand name redundancy
        
    }
}

#Preview {
    SellerEditProduct()
}