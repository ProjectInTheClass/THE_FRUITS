//
//  CustomerManager.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/21/24.
//

import Firebase

extension FireStoreManager{
    
    func fetchCart() async {
        do {
            let cartDocuments = try await db.collection("customer").document(self.customerid).collection("cart").getDocuments()
            
            guard let document = cartDocuments.documents.first else {
                print("No cart documents found")
                return
            }
            
            let cart = try document.data(as: CartModel.self)
            
            DispatchQueue.main.async {
                self.cart = cart // 상태 업데이트를 메인 스레드에서 수행
            }
        } catch {
            print("fetch cart error: \(error.localizedDescription)")
        }
    }

    func fetchBrand(brandId: String, completion: @escaping (BrandModel?) -> Void) {
        db.collection("brand").document(brandId).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let brand = try document.data(as: BrandModel.self)
                    completion(brand) // 성공적으로 데이터를 가져오면 반환
                } catch {
                    print("Error decoding document into BrandModel: \(error.localizedDescription)")
                    completion(nil) // 에러 발생 시 nil 반환
                }
            } else {
                print("Document does not exist")
                completion(nil) // 문서가 존재하지 않을 경우 nil 반환
            }
        }
    }
    
    func asyncFetchBrand(brandId: String) async throws -> BrandModel? {
        let document = try await db.collection("brand").document(brandId).getDocument()
        if document.exists {
            print("패치완료")
            return try document.data(as: BrandModel.self)
        } else {
            print("Document does not exist")
            return nil
        }
    }
    
    func getCartBrandName() async -> String? {
        // 1. Cart 데이터를 확인
        guard let cart = cart else {
            print("Cart is not loaded")
            return nil
        }
        
        do {
            // 2. Brand ID를 사용해 브랜드 데이터를 가져옴
            if let brand = try await asyncFetchBrand(brandId: cart.brandid) {
                return brand.name // 성공적으로 가져온 브랜드 이름 반환
            } else {
                print("Brand not found for brandId: \(cart.brandid)")
                return nil
            }
        } catch {
            print("Error fetching brand for cart: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getDelCost() async->Int?{
        guard let cart = cart else {
            print("Cart is not loaded")
            return nil
        }
        
        do {
            // 2. Brand ID를 사용해 브랜드 데이터를 가져옴
            if let brand = try await asyncFetchBrand(brandId: cart.brandid) {
                return brand.deliverycost // 성공적으로 가져온 브랜드 이름 반환
            } else {
                print("Brand not found for brandId: \(cart.brandid)")
                return nil
            }
        } catch {
            print("Error fetching brand for cart: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func fetchCartDetails() async throws -> [OrderSummary] {
            // Ensure cart exists
            guard let cart = self.cart else {
                throw NSError(domain: "CartError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cart not loaded"])
            }

            var orderSummaries: [OrderSummary] = []

            for orderprodId in cart.orderprodid {
                print("orderprod id is\(orderprodId)")
                // Fetch each orderprod object
                let orderProd = try await fetchOrderProd(orderprodId: orderprodId)

                // Fetch product details for each product in the order
                var productDetails: [ProductDetail] = []
                for product in orderProd.products {
                    let productModel = try await fetchProduct(productId: product.productid)
                    let detail = ProductDetail(
                        productName: productModel.prodtitle,
                        price: productModel.price,
                        num: product.num
                    )
                    productDetails.append(detail)
                }

                // Add summary for this orderprod
                let summary = OrderSummary(orderprodid: orderProd.orderprodid, products: productDetails, selected: orderProd.selected)
                orderSummaries.append(summary)

            }

            return orderSummaries
        }

        private func fetchOrderProd(orderprodId: String) async throws -> OrderProdModel {
            let document = try await db.collection("orderprod").document(orderprodId).getDocument()
            guard let orderProd = try document.data(as: OrderProdModel?.self) else {
                throw NSError(domain: "OrderProdError", code: 0, userInfo: [NSLocalizedDescriptionKey: "OrderProd not found for id: \(orderprodId)"])
            }
            return orderProd
        }

    private func fetchProduct(productId: String) async throws -> ProductModel {
        let document = try await db.collection("product").document(productId).getDocument()
        guard let product = try document.data(as: ProductModel?.self) else {
            throw NSError(domain: "ProductError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Product not found for id: \(productId)"])
        }
        return product
    }
  

    
    
    
}
