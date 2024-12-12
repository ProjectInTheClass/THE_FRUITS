//
//  CustomerManager.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/21/24.
//

import Firebase
import Foundation

extension FireStoreManager{
    func fetchOrders() async throws -> [String] {
        do {
            // Firestore에서 customer 문서 가져오기
            let customerDoc = try await db.collection("customer").document(self.customerid).getDocument()
            
            // orders 배열 필드 가져오기
            guard let customerData = customerDoc.data(),
                  let orderIds = customerData["orders"] as? [String] else {
                print("No orders found for customer.")
                return []
            }
            
            // orders 배열 반환
            return orderIds
        } catch {
            print("Error fetching customer orders: \(error.localizedDescription)")
            throw error // 에러를 상위로 전달
        }
    }


    func fetchCart() async {
        do {
            let cartDocuments = try await db.collection("customer").document(self.customerid).collection("cart").getDocuments()
            
            guard let document = cartDocuments.documents.first else {
                print("No cart documents found")
                return
            }
            
            let cart = try document.data(as: CartModel.self)
            
            // cart 업데이트 완료 후 알림
            await MainActor.run {
                self.cart = cart
                print("cart id \(cart.cartid)")
            }
        } catch {
            print("fetch cart error: \(error.localizedDescription)")
        }
    }
    
    
    func asyncFetchBrand(brandId: String) async throws -> BrandModel? {
        guard !brandId.isEmpty else {
            print("Invalid brandId: Empty string")
            return nil
        }

        let document = try await db.collection("brand").document(brandId).getDocument()
        if document.exists {
            return try document.data(as: BrandModel.self)
        } else {
            print("Document does not exist for brandId: \(brandId)")
            return nil
        }
    }

    
    
    func getCartBrand() async -> BrandModel? {
        // 1. Cart 데이터를 확인
        guard let cart = cart else {
            print("Cart is not loaded in getCartBrandName")
            await fetchCart()
            return nil
        }
        
        do {
            // 2. Brand ID를 사용해 브랜드 데이터를 가져옴
            if let brand = try await asyncFetchBrand(brandId: cart.brandid) {
                return brand // 성공적으로 가져온 브랜드 이름 반환
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
    
    func fetchOrderProd(orderprodId: String) async throws -> OrderProdModel {
        let document = try await db.collection("orderprod").document(orderprodId).getDocument()
        guard let orderProd = try document.data(as: OrderProdModel?.self) else {
            throw NSError(domain: "OrderProdError", code: 0, userInfo: [NSLocalizedDescriptionKey: "OrderProd not found for id: \(orderprodId)"])
        }
        return orderProd
    }
    
    func fetchProduct(productId: String) async throws -> ProductModel {
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
    
    
    
    
    func deleteOrderProd(orderprodId: String) async throws {
        let orderprodCollection = db.collection("orderprod")
        let cartCollection = db.collection("customer").document(self.customerid).collection("cart")
        // 1. `orderprod` 컬렉션에서 해당 문서 삭제
        let orderprodSnapshot = try await orderprodCollection
            .whereField("orderprodid", isEqualTo: orderprodId)
            .getDocuments()
        
        guard !orderprodSnapshot.documents.isEmpty else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "OrderProd document not found."])
        }
        
        for document in orderprodSnapshot.documents {
            try await document.reference.delete()
        }
        
        // 2. `cart` 컬렉션에서 해당 `orderprodid`를 배열에서 삭제
        let cartSnapshot = try await cartCollection
            .whereField("cartid", isEqualTo: self.cart?.cartid)
            .getDocuments()
        
        guard let cartDocument = cartSnapshot.documents.first else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart document not found."])
        }
        
        try await cartDocument.reference.updateData([
            "orderprodid": FieldValue.arrayRemove([orderprodId]) // 배열에서 ID 삭제
        ])
        
        do {
                try await deleteCartBrandIfOrderProdIsEmpty()
        } catch {
            print("Error clearing brandid: \(error.localizedDescription)")
        }
        
        print("Successfully deleted orderprodid \(orderprodId) from both orderprod and cart.")
    }
    
    func fetchSellerName(sellerId: String) async throws -> String? {
        do {
            // Firestore에서 문서 가져오기
            let document = try await db.collection("seller").document(sellerId).getDocument()
            
            // "name" 필드 가져오기
            if let name = document.data()?["name"] as? String {
                return name
            }else {
                print("Name field does not exist for sellerId: \(sellerId)")
                return nil
            }
        } catch {
            print("Error fetching seller name: \(error.localizedDescription)")
            throw error
        }
    }
    
    func addOrder(brand: BrandModel, orderSummaries: [OrderSummary], totalPrice: Int) async throws -> (OrderModel, [OrderSummary]) {
        var orderList: [OrderSummary] = []
        let selectedOrderSummary = orderSummaries.filter { $0.selected }
        
        let selectedOrderProdIds = selectedOrderSummary.map { $0.orderprodid }
        let orderRef = db.collection("order").document()
        
        let cartCollection = db.collection("customer").document(self.customerid).collection("cart")
        let orderNum = UUID().uuidString.prefix(8)
        
        let order = OrderModel(
            orderid: orderRef.documentID,
            orderdate: dateToString(Date()),
            brandid: brand.brandid,
            products: selectedOrderProdIds,
            totalprice: totalPrice,
            delcost: brand.deliverycost,
            account: brand.account,
            bank: brand.bank,
            sellername: try await fetchSellerName(sellerId: brand.sellerid)!,
            customername: self.customer?.name ?? "Unknown Customer",
            customerphone: self.customer?.phone ?? "Unknown Phone",
            recaddress: self.customer?.address ?? "",
            recname: self.customer?.name ?? "",
            recphone: self.customer?.phone ?? "",
            state: 0,
            delnum: "0",
            delname: "",
            ordernum: String(orderNum)
        )
        
        // Firestore에 데이터 저장
        try await addOrderToFirestore(orderRef: orderRef, order: order)
        
        // 각 orderprodid에 대해 deleteOrderProd 호출
//        for orderprodId in selectedOrderProdIds {
//            try await deleteOrderProd(orderprodId: orderprodId)
//        }
//        print("All selected OrderProd IDs have been deleted.")
        
        // cart 에서만 삭제되도록
        let cartSnapshot = try await cartCollection
            .whereField("cartid", isEqualTo: self.cart?.cartid)
            .getDocuments()
        
        guard let cartDocument = cartSnapshot.documents.first else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart document not found."])
        }
        for orderprodId in selectedOrderProdIds {
            try await cartDocument.reference.updateData([
                "orderprodid": FieldValue.arrayRemove([orderprodId]) // 배열에서 ID 삭제
            ])
            
            print("Successfully deleted orderprodid \(orderprodId) from both orderprod and cart.")
        }
        
        // cart 가 비어있다면, brandid 삭제
        do {
                try await deleteCartBrandIfOrderProdIsEmpty()
        } catch {
            print("Error clearing brandid: \(error.localizedDescription)")
        }
        
        // Firestore의 customer의 orders 배열에 orderid 추가
        if let customerId = self.customer?.customerid {
            let customerRef = db.collection("customer").document(customerId)
            try await customerRef.updateData([
                "orders": FieldValue.arrayUnion([order.orderid])
            ])
            print("Order ID \(order.orderid) successfully added to customer's orders.")
        } else {
            print("Customer ID not found. Unable to update orders.")
        }
        
        // 선택된 주문 요약 목록 반환 준비
        orderList = selectedOrderSummary
        
        // OrderModel과 [OrderSummary]를 튜플로 반환
        return (order, orderList)
    }

    
    // make order in cart
    func addOrderToFirestore(orderRef: DocumentReference, order: OrderModel) async throws {
        do {
            // Codable 구조체를 딕셔너리로 변환
            let orderData = try JSONEncoder().encode(order)
            if let dictionary = try JSONSerialization.jsonObject(with: orderData, options: []) as? [String: Any] {
                try await orderRef.setData(dictionary) // DocumentReference를 사용하여 데이터 설정
                print("Order successfully added!")
            }
        } catch {
            print("Error encoding order: \(error.localizedDescription)")
        }
    }
    
    func dateToString(_ date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US") // 영어 형식으로 설정
        return dateFormatter.string(from: date)
    }

    func fetchOrder(orderId: String) async throws -> (OrderModel, [OrderSummary], BrandModel) {
        let orderRef = db.collection("order").document(orderId)
        let orderDocument = try await orderRef.getDocument()
        
        guard let orderData = try orderDocument.data(as: OrderModel?.self) else {
            throw NSError(domain: "FetchError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Order not found for id: \(orderId)"])
        }
        
        let order = orderData
        var orderSummaries: [OrderSummary] = []
        
        
        for orderprodId in order.products {
        
            let orderProd = try await fetchOrderProd(orderprodId: orderprodId)
            
        
            var productDetails: [ProductDetail] = []
            for products in orderProd.products {
                let product = try await fetchProduct(productId: products.productid)
                let productDetail = ProductDetail(
                    productid: product.id,
                    productName: product.prodtitle,
                    price: product.price,
                    num: products.num
                )
                productDetails.append(productDetail)
            }
            
            let orderSummary = OrderSummary(
                orderprodid: orderprodId,
                products: productDetails,
                selected: true
            )
            
            orderSummaries.append(orderSummary)
        }
        
        
        let brand: BrandModel = try await asyncFetchBrand(brandId: order.brandid)!
        
        return (order, orderSummaries, brand)
    }
    
    func updateOrderAddress(orderId: String, newAddress: String, newName: String, newPhone: String) async throws {
        
        let orderRef = db.collection("order").document(orderId)
        
        do {
            
            try await orderRef.updateData([
                "recaddress": newAddress,
                "recname": newName,
                "recphone": newPhone
            ])
            print("Order \(orderId) successfully updated with new details.")
        } catch {
            print("Error updating order \(orderId): \(error.localizedDescription)")
            throw error
        }
    }

    func updateOrderInfo(orderId: String, newName: String, newPhone: String) async throws {
        
        let orderRef = db.collection("order").document(orderId)
        
        do {
            try await orderRef.updateData([
                "customername": newName,
                "customerphone": newPhone
            ])
            print("Order \(orderId) successfully updated with new details.")
        } catch {
            print("Error updating order \(orderId): \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteCartBrandIfOrderProdIsEmpty() async throws {
        do {
            let cartDocuments = try await db.collection("customer").document(self.customerid).collection("cart").getDocuments()
            
            guard let document = cartDocuments.documents.first else {
                print("No cart documents found")
                return
            }
            
            var cart = try document.data(as: CartModel.self)
            
            // `orderprodid`가 비어있는지 확인
            if cart.orderprodid.isEmpty {
                // `brandid` 값을 비움
                cart.brandid = ""
                
                // Firestore에 업데이트된 cart 저장
                try await db.collection("customer").document(self.customerid).collection("cart").document(cart.cartid).setData(from: cart)
                
                // 업데이트된 cart를 로컬 상태에 반영
                await MainActor.run {
                    self.cart = cart
                    print("Cart brandid cleared for cart id \(cart.cartid)")
                }
            } else {
                print("Orderprodid is not empty, no changes made.")
            }
        } catch {
            print("deleteCartBrandIfOrderProdIsEmpty error: \(error.localizedDescription)")
        }
    }
    
    func isCartBrandAvailable() async -> Bool {
        do {
            // Firestore에서 cart 데이터를 가져옴
            let cartDocuments = try await db.collection("customer").document(self.customerid).collection("cart").getDocuments()
            
            guard let document = cartDocuments.documents.first else {
                print("No cart documents found")
                return false
            }
            
            // CartModel로 디코딩
            let cart = try document.data(as: CartModel.self)
            
            // cart의 brandid가 비어 있지 않은지 확인
            return !cart.brandid.isEmpty
        } catch {
            print("Error checking cart brand availability: \(error.localizedDescription)")
            return false
        }
    }
    
   
    func updateCustomerInfo(customerId: String, name: String, phone: String, password: String) async throws {
        let db = Firestore.firestore()
        let customerRef = db.collection("customer").document(customerId)
        
        do {
            try await customerRef.updateData([
                "name": name,
                "phone": phone,
                "password": password
            ])
        } catch {
            throw error
        }
        self.fetchCustomer()
    }
    
    func updateCustomerAddress(customerId: String, address: String) async throws {
        let db = Firestore.firestore()
        let customerRef = db.collection("customer").document(customerId)
        
        do {
            try await customerRef.updateData([
                "address": address
            ])
        } catch {
            throw error
        }
        self.fetchCustomer()
    }
}




