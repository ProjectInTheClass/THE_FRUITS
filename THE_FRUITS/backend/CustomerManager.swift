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

    
    func asyncFetchBrand(brandId: String) async throws -> BrandModel? {
        let document = try await db.collection("brand").document(brandId).getDocument()
        if document.exists {
            return try document.data(as: BrandModel.self)
        } else {
            print("Document does not exist")
            return nil
        }
    }
    
    func getCartBrandName() async -> String? {
        // 1. Cart 데이터를 확인
        guard let cart = cart else {
            print("Cart is not loaded in getCartBrandName")
            await fetchCart()
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
            print("Cart is not loaded in getDelCost")
            await fetchCart()
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
//            if cart == nil {
//                print("Cart is not loaded. Fetching cart...")
//                await fetchCart()
//            }
            // Ensure cart exists
            guard let cart = cart else {
                print("cart is not loaded in fetchCartDetails")
                await fetchCart()
                throw NSError(domain: "CartError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cart not loaded"])
            }

            var orderSummaries: [OrderSummary] = []

            for orderprodId in cart.orderprodid {
               // print("orderprod id is\(orderprodId)")
                // Fetch each orderprod object
                let orderProd = try await fetchOrderProd(orderprodId: orderprodId)

                // Fetch product details for each product in the order
                var productDetails: [ProductDetail] = []
                for product in orderProd.products {
                    let productModel = try await fetchProduct(productId: product.productid)
                    let detail = ProductDetail(
                        //add product id
                        productid : productModel.productid,
                        productName: productModel.prodtitle,
                        price: productModel.price,
                        num: product.num
                    )
                    productDetails.append(detail)
                }

                // Add summary for this orderprod
                var summary = OrderSummary(orderprodid: orderProd.orderprodid, products: productDetails, selected: orderProd.selected)
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
    
    
  
    func updateOrderProdSelected(orderprodId: String) async throws {
        do {
            // 현재 문서 가져오기
            let document = try await db.collection("orderprod").document(orderprodId).getDocument()
            guard let data = document.data(),
                  let currentSelected = data["selected"] as? Bool else {
                print("Field 'selected' not found or invalid")
                return
            }

            // 'selected' 값을 반대로 토글
            let newSelected = !currentSelected
            try await db.collection("orderprod").document(orderprodId).updateData([
                "selected": newSelected
            ])

            print("Document updated: selected -> \(newSelected)")
        } catch {
            print("Error updating document in updateOrderProd: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func updateOrderProdQuantity(orderprodId: String, productId: String, newQuantity: Int) async throws {
        do {
            let document = db.collection("orderprod").document(orderprodId)
            
            // 현재 orderprod 데이터를 가져오기
            let snapshot = try await document.getDocument()
            guard var data = snapshot.data(),
                  var products = data["products"] as? [[String: Any]] else {
                throw NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Products not found in the document"])
            }
            
            // 특정 productid의 num 값을 업데이트
            for (index, product) in products.enumerated() {
                if let id = product["productid"] as? String, id == productId {
                    products[index]["num"] = newQuantity
                    print(newQuantity, products[index]["num"])
                    break
                }
            }
            
            // Firestore에 업데이트된 products 배열 저장
            try await document.updateData([
                "products": products
            ])
            
            print("Product quantity updated successfully.")
        } catch {
            print("Error updating product quantity: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    // make order in cart
    func addOrderToFirestore(order: OrderModel) {
        
        do {
            // Codable 구조체를 딕셔너리로 변환
            let orderData = try JSONEncoder().encode(order)
            if let dictionary = try JSONSerialization.jsonObject(with: orderData, options: []) as? [String: Any] {
                db.collection("orders").document(order.orderid).setData(dictionary) { error in
                    if let error = error {
                        print("Error adding order: \(error.localizedDescription)")
                    } else {
                        print("Order successfully added!")
                    }
                }
            }
        } catch {
            print("Error encoding order: \(error.localizedDescription)")
        }
    }


}