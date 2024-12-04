//
//  SellerEditProduct.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI

// should contain already uploaded info
struct SellerEditProduct: View{
    @EnvironmentObject var firestoreManager: FireStoreManager
    @Binding var product: ProductModel
    
    @State private var productTitle: String
    @State private var productImage: String
    @State private var imageData: Data? = nil
    @State private var productInfo: String
    @State private var productPrice: Int
    @State private var productType: String
    
    @State private var selectedTab = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(product: Binding<ProductModel>) {
        _product = product
        _productTitle = State(initialValue: product.wrappedValue.prodtitle)
        _productImage = State(initialValue: product.wrappedValue.imageUrl)
        _productInfo = State(initialValue: product.wrappedValue.info)
        _productPrice = State(initialValue: product.wrappedValue.price)
        _productType = State(initialValue: product.wrappedValue.type)
    }
    
    var body: some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // product name
                Text("상품 이름")
                HStack {
                    TextField(product.prodtitle.isEmpty ? "상품 입력" : product.prodtitle, text: $productTitle)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                }
                
                // product image
                /*VStack {
                    Text("상품 이미지")
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }*/
                UploadImageField(title: "상품 이미지", imageUrl: $productImage, imageData: $imageData, id: product.productid)
                
                // product info
                VStack(alignment: .leading) {
                    Text("상품 소개")
                    TextField(product.info.isEmpty ? "상품을 소개해주세요!" : product.info, text: $productInfo)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                // product price
                VStack(alignment: .leading) {
                    Text("상품 가격")
                    TextField(productPrice == 0 ? "상품 가격을 입력해주세요." : "\(productPrice)", value: $productPrice, formatter: NumberFormatter())
                        .keyboardType(.numberPad)  // To ensure only number input
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                // product type
                InputField(title: "상품 종류", placeholder: product.type.isEmpty ? "상품 종류를 입력해주세요." : product.type, text: $productType)
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            let imageURL = try await uploadImageToFirebase(imageData: imageData, fieldName: "image")
                            
                            // Update product in Firestore
                            product.prodtitle = productTitle
                            product.imageUrl = imageURL
                            product.info = productInfo
                            product.price = productPrice
                            product.type = productType
                            
                            // Call FirestoreManager to update the product
                            try await firestoreManager.editProduct(product: product)
                            print("Product updated successfully.")
                            
                            // Navigate back after updating
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error updating product: \(error)")
                        }
                    }
                }) {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

#Preview {
    SellerEditProduct(product: .constant(ProductModel(productid: "1", prodtitle: "Apple", price: 3000, info: "Fresh apple", imageUrl: "apple.jpg", type: "Fruit", soldout: false)))
}
