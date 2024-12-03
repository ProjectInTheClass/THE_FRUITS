//
//  SellerManager.swift
//  THE_FRUITS
//
//

import Firebase

extension FireStoreManager{
    func fetchBrands() async throws -> [BrandModel] {
        let db = Firestore.firestore()
        
        // Ensure seller ID is not empty
        guard !sellerid.isEmpty else {
            print("Seller ID is empty. Cannot fetch brands.")
            return []
        }
        
        // Query the Firestore collection for all brands matching the seller ID
        let querySnapshot = try await db.collection("brand")
            .whereField("sellerid", isEqualTo: sellerid)
            .getDocuments()
        
        // Decode each document into a `BrandModel` object
        let brands = try querySnapshot.documents.compactMap { document in
            try document.data(as: BrandModel.self)
        }
        
        if brands.isEmpty {
            print("No brands found for seller ID: \(sellerid)")
        } else {
            print("Successfully fetched \(brands.count) brands.")
        }
        
        return brands
    }
    
    func fetchBrandProducts(for brandId: String) async throws -> [ProductModel] {
        let db = Firestore.firestore()
        var products: [ProductModel] = []
        
        let querySnapshot = try await db.collection("brand")
                .whereField("brandid", isEqualTo: brandId)
                .getDocuments()

            // Extract productid values from the documents
            let productIDs = querySnapshot.documents.flatMap { document in
                document.data()["productid"] as? [String] ?? []
            }
        
        for productID in productIDs {
            let documentSnapshot = try await db.collection("product").document(productID).getDocument()
            
            if let product = try? documentSnapshot.data(as: ProductModel.self) {
                products.append(product)
            }
        }
        if products.isEmpty {
            print("No products found for the given product IDs.")
        } else {
            print("Successfully fetched \(products.count) products.")
        }
        
        return products
    }
    
    func deleteProduct(productId: String, brandId: String) async throws {
        let productRef = db.collection("product").document(productId)
        try await productRef.delete()
        
        let brandRef = db.collection("brand").document(brandId)
        try await brandRef.updateData([
            "productid": FieldValue.arrayRemove([productId])
        ])
    }
    
    func editProduct(product: ProductModel) async throws {
        let db = Firestore.firestore()
        let productRef = db.collection("product").document(product.productid)
        
        // Update the product document with the new information
        try await productRef.setData([
            "prodtitle": product.prodtitle,
            "imageUrl": product.imageUrl,
            "info": product.info,
            "price": product.price,
            "type": product.type
        ])
        print("Product updated successfully.")
    }
    
    func addBrand(brand: BrandModel) async throws {
        // Reference to the "brands" collection in Firestore
        let brandRef = db.collection("brand").document()
        
        var newBrand = brand
        newBrand.brandid = brandRef.documentID
        newBrand.sellerid = self.sellerid
        
        // Save the brand model to Firestore
        do {
            try brandRef.setData(from: newBrand)
            
            print("seller: \(self.sellerid)")
            let sellerRef = db.collection("seller").document(self.sellerid)
            try await sellerRef.updateData([
                "brands": FieldValue.arrayUnion([newBrand.brandid])
            ])
            print("Brand data saved successfully!")
        } catch {
            print("Error saving brand data: \(error.localizedDescription)")
        }
    }
    
    func addProduct(product: ProductModel, brandid: String) async throws {
        // Reference to the "brands" collection in Firestore
        let productRef = db.collection("product").document()
        
        var newProduct = product
        newProduct.productid = productRef.documentID
        
        do {
            try productRef.setData(from: newProduct)
            
            let brandRef = db.collection("brand").document(brandid)
            try await brandRef.updateData([
                "productid": FieldValue.arrayUnion([newProduct.productid])
            ])
            print("product data saved successfully!")
        } catch {
            print("Error saving product data: \(error.localizedDescription)")
        }
    }
    
    func fetchBrandDetails(brandId: String) async throws -> BrandEditModel {
        let document = try await Firestore.firestore().collection("brand").document(brandId).getDocument()
        guard let data = document.data() else { throw NSError() }
        return BrandEditModel(
            brandid: document.documentID,
            name: data["name"] as? String ?? "",
            logo: data["logo"] as? String ?? "",
            thumbnail: data["thumbnail"] as? String ?? "",
            info: data["info"] as? String ?? "",
            sigtype: data["sigtype"] as? [String] ?? ["", "", ""],
            bank: data["bank"] as? String ?? "",
            account: data["account"] as? String ?? "",
            address: data["address"] as? String ?? ""
        )
    }
    
    func updateBrand(brand: BrandEditModel) async throws {
        let data: [String: Any] = [
            "name": brand.name,
            "logo": brand.logo,
            "thumbnail": brand.thumbnail,
            "info": brand.info,
            "bank": brand.bank,
            "account": brand.account,
            "address": brand.address
        ]
        try await Firestore.firestore().collection("brand").document(brand.brandid).setData(data, merge: true)
    }
}
