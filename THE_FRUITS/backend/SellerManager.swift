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
}
