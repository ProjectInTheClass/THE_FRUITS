//
//  SellerManager.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/21/24.
//

import Firebase

extension FireStoreManager{
    func fetchBrands() { // to fetch brands owned by user with sellerid
        guard !sellerid.isEmpty else {
            print("Seller ID is empty. Cannot fetch brands.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("brand")
            .whereField("sellerid", isEqualTo: sellerid)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching brands: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No brands found")
                    return
                }
                self.brands = documents.compactMap { document in
                    let data = document.data()
                    guard let name = data["name"] as? String,
                          let logo = data["logo"] as? String else {
                        return nil
                    }
                    print("sellerid: ", self.sellerid)
                    print("name: ", name)
                    print("logo: ", logo)
                    return Brand(name: name, logo: logo)
                }
            }
    }
}
