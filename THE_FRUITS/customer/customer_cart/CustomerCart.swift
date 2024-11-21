//
//  Cart.swift
//  THE_FRUITS
//
//  Created by 박지은 on 10/31/24.
//

import SwiftUI



struct PriceSection: View {
    
    var orderAmount: Int = 16000
    var deliveryFee: Int = 3000
    var totalAmount: Int {
        orderAmount + deliveryFee
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color("lightGray"))
            .frame(width: 360, height: 170)
            .overlay(
                VStack(){
                   Text("결제 금액")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    Divider()
                        .padding(.bottom, 10)
                    VStack(){
                        HStack {
                            Text("주문 금액")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Text("\(orderAmount) 원")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                        .padding(.bottom,5)
                        
                        HStack {
                            Text("배송비")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Text("\(deliveryFee) 원")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                        .padding(.bottom,5)
                    }
                    Divider()
                    HStack {
                        Text("최종결제금액")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
                        Text("\(totalAmount) 원")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                    }
                    
               }
        )
    }
}

//struct FetchBrand: View {
//    @EnvironmentObject var firestoreManager: FireStoreManager
//    @State private var brand: BrandModel? // 브랜드 데이터를 저장할 상태 변수
//    @State private var product: [ProductModel?]
//    
//    @State private var products: [ProductModel] = [] // ProductModel 배열
//    let productId : [String] = ["8bdNHbRMQBxf166p8jJ7","AzyVlJfAZBr6fr9PGgWc"]
//    
//
//    var body: some View {
//        VStack {
//            if let brand = brand {
//                // 브랜드 데이터가 로드되었을 때 UI 표시
//                Text("Brand ID: \(brand.brandid)")
//                Text("Brand Name: \(brand.name)")
//            } else {
//                Text("Loading brand data...")
//                    .foregroundColor(.gray)
//            }
//            
//            if products.isEmpty {
//                            Text("Loading product data...")
//                                .foregroundColor(.gray)
//            } else {
//                List(products, id: \.productid) { product in
//                    VStack(alignment: .leading) {
//                        Text("Product Name: \(product.prodtitle)")
//                        Text("Product Price: \(product.price)")
//                    }
//                }
//            }
//        }
//        .onAppear {
//            firestoreManager.fetchBrand(brandId: "3jzUOdeiSvD5gtZGsTee") { fetchedBrand in
//                if let fetchedBrand = fetchedBrand {
//                    DispatchQueue.main.async {
//                        self.brand = fetchedBrand // 데이터를 상태 변수에 저장
//                    }
//                }
//            }
//            firestoreManager.fetchProducts(for: productId) { fetchedProducts in
//                DispatchQueue.main.async {
//                    self.products = fetchedProducts
//                }
//            }
//        }
//    }
//}

struct CustomerCart: View {
    var body: some View {
        NavigationStack {
            PriceSection()
                .padding(.bottom,20)
            CustomButton(
                title: "주문하기",
                background: Color("darkGreen"),
                foregroundColor: .white,
                width: 140,
                height: 33,
                size: 14,
                cornerRadius: 15,
                action: {
                    //submitUserInfo()
                    }
                )
            }
        }
    }




#Preview {
    CustomerCart()
        .environmentObject(FireStoreManager())
}
