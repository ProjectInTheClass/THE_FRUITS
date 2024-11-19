//
//  FirebaseManager.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/28/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class FireStoreManager: ObservableObject {
    @Published var sellerid: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var brands: [Brand] = []
    @Published var customerid: String = ""
    
    /*init() {
        fetchData()
    }*/
    func fetchData() { // firebase test with specific user
            let db = Firestore.firestore()
            let docRef = db.collection("seller").document("troY2ZvhHxGfrSDCIggI")
            docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }
                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        self.name = data["name"] as? String ?? ""
                        self.username = data["username"] as? String ?? ""
                        self.password = data["password"] as? String ?? ""
                    }
                }
            }
    }
    
    func fetchUserData(userType: String, userId: String) {
        let collection = userType == "customer" ? "customer" : "seller"
        let db = Firestore.firestore()
        db.collection(collection).document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if userType == "seller" { // store sellerid if it is seller
                    self.sellerid = data?["sellerid"] as? String ?? ""
                    print("sellerid in fetch: ", self.sellerid)
                }
                else if userType == "customer"{
                    self.customerid = data?["customerid"] as? String ?? ""
                    print("customerid in fetch: ", self.customerid)
                }
                self.name = data?["name"] as? String ?? ""
                self.username = data?["username"] as? String ?? ""
                self.password = data?["password"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
    
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


