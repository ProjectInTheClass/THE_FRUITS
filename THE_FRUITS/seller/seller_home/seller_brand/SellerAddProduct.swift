//
//  SellerAddProduct.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI

struct SellerAddProduct: View{
    @EnvironmentObject var firestoreManager: FireStoreManager
    @Binding var brandid: String
    @Environment(\.presentationMode) var presentationMode
    
    @State private var productName: String = ""
    @State private var productImage: String = ""
    @State private var productInfo: String = ""
    @State private var productPrice: Int = 0
    @State private var productType: String = ""
    
    @State private var selectedTab = 0
    @State private var sellerid: String = ""
    
    // for modal sheet
    @State private var isModalPresented = false
    @State private var shouldNavigate = false
    
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
                
                VStack(alignment: .leading) {
                    Text("상품 가격")
                    TextField("상품 가격을 입력해주세요.", value: $productPrice, formatter: NumberFormatter())
                        .keyboardType(.numberPad)  // To ensure only number input
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                InputField(title: "상품 품종", placeholder: "상품 품종을 입력해주세요. (ex. 사과, 딸기 등)", text: $productType)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await saveProduct()
                        isModalPresented = true // 모달창 표시
                    }
                }) {
                    Text("등록하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert("등록되었습니다.", isPresented: $isModalPresented, actions: {
                    Button("확인", role: .cancel) { isModalPresented = false; shouldNavigate = true; presentationMode.wrappedValue.dismiss() }
                })
            }
            .padding()
        }
    }
    
    func checkProductNameRedundancy() {
        // checking for brand name redundancy
        
    }
    
    func saveProduct() async {
        let productModel = ProductModel(
            productid: "0",
            prodtitle: productName,
            price: productPrice,
            info: productInfo,
            imageUrl: productImage,
            type: productType,
            soldout: false
        )
        
        do {
            try await firestoreManager.addProduct(product: productModel, brandid: brandid)
        } catch {
            // Handle error (you can print the error or show an alert)
            print("Error saving brand: \(error)")
        }
    }
}

/*#Preview {
    SellerAddProduct()
}
*/
