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
    @State private var isUpdated = false
    
    @State private var selectedTab = 0
    
    @Environment(\.dismiss) var dismiss
    
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
                    TextField("상품 입력", text: $productTitle)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                }
                
                // product image
                UploadImageField(title: "상품 이미지", imageUrl: $productImage, imageData: $imageData, id: "product")
                
                // product info
                VStack(alignment: .leading) {
                    Text("상품 소개")
                    TextField("상품을 소개해주세요!", text: $productInfo)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                // product price
                VStack(alignment: .leading) {
                    Text("상품 가격")
                    TextField("상품 가격을 입력해주세요.", value: $productPrice, formatter: NumberFormatter())
                        .keyboardType(.numberPad)  // To ensure only number input
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                // product type
                InputField(title: "상품 종류", placeholder: product.type.isEmpty ? "상품 종류를 입력해주세요." : product.type, text: $productType)
                
                Spacer()
                
                if isUpdated {
                    ProgressView("Updating...")
                }
                Button(action: {
                    Task {
                        await updateProductInFirebase()
                        //isUpdated = true
                        
                        // Navigate back after updating
                        //presentationMode.wrappedValue.dismiss()
                        
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
    
    func updateProductInFirebase() async{
        isUpdated = true
        defer { isUpdated = false }
        do {
            //var imageURL = product.imageUrl
            print("in update product in firebase")
            
            if let newImageData = imageData, !productImage.isEmpty {
                try await deleteImageFromFirebaseStorage(urlString: product.imageUrl)
            }
            
            if let newImageData = imageData {
                print("Uploading new logo...")
                if let uploadedImageURL = try await uploadImageIfNeeded(data: newImageData, path: "images/products/\(UUID().uuidString).jpg"){
                    productImage = uploadedImageURL ?? ""
                    print("Image uploaded: \(productImage)")
                }
            }
            
            // Update product in Firestore
            product.prodtitle = productTitle
            product.imageUrl = productImage
            product.info = productInfo
            product.price = productPrice
            product.type = productType
            
            let updatedProduct = ProductModel(
                productid: product.productid,
                prodtitle: productTitle,
                price: productPrice,
                info: productInfo,
                imageUrl: productImage,
                type: productType,
                soldout: product.soldout
            )
            
            // Call FirestoreManager to update the product
            try await firestoreManager.editProduct(product: updatedProduct)
            print("Product updated successfully.")
            
            // Navigate back after updating
            //isUpdated = true
            dismiss()
            //presentationMode.wrappedValue.dismiss()
        }
        catch{
            print("Error updating product: \(error)")
        }
    }
}

#Preview {
    SellerEditProduct(product: .constant(ProductModel(productid: "1", prodtitle: "Apple", price: 3000, info: "Fresh apple", imageUrl: "apple.jpg", type: "Fruit", soldout: false)))
}
