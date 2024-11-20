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
    @Published var userId: String = ""
    @Published var password: String = ""
    @Published var brands: [Brand] = []
    @Published var cartId:String=""
    @Published var brandname:String=""//을 전역변수로
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
    /* storeName으로 브랜드테이블에 접근*/
    func fetchProductIdsForBrand(storeName: String, completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        db.collection("brand")
            .whereField("name", isEqualTo: storeName)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching brand: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No brand found with storeName: \(storeName)")
                    completion([])
                    return
                }
                
                let document = documents[0]
                print("Fetched brand document: \(document.data())")
                
                if let productids = document.data()["productid"] as? [Any] {
                    // `compactMap`을 사용하여 DocumentReference와 String 처리
                    let ids = productids.compactMap { item -> String? in
                        if let ref = item as? DocumentReference {
                            return ref.documentID
                        } else if let id = item as? String {
                            return id
                        } else {
                            return nil
                        }
                    }
                    completion(ids)
                } else {
                    print("No productid array found in brand document")
                    completion([])
                }
            }
    }
    
    
    
    func fetchProducts(for productids: [String], completion: @escaping ([ProductItem]) -> Void) {
        let db = Firestore.firestore()
        var fetchedProducts: [ProductItem] = []
        let dispatchGroup = DispatchGroup() // 동기 처리를 위해 DispatchGroup 사용
        
        for productid in productids {
            dispatchGroup.enter()
            db.collection("product").document(productid).getDocument { document, error in
                if let error = error {
                    print("Error fetching product \(productid): \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    print("Fetched product document for ID \(productid): \(document.data() ?? [:])")
                    if let data = document.data(), let price = data["price"] as? Int {
                        print("Price: \(price)")
                    } else {
                        print("Price not found or invalid")
                    }
                    
                    if let data = document.data() {
                        let id = data["productid"] as? String ?? "Unknown"
                        let name = data["info"] as? String ?? "No Info"
                        let price = data["price"] as? Int ?? 0
                        let imageUrl = data["imageUrl"] as? String ?? ""
                        print("Creating ProductItem with id: \(id), name: \(name), price: \(price), imageUrl: \(imageUrl)")
                        let product = ProductItem(id: id, name: name, price: price, imageUrl: imageUrl)
                        fetchedProducts.append(product)
                    } else {
                        print("No data found for document \(productid)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("Final fetched products: \(fetchedProducts)")
                completion(fetchedProducts) // 모든 데이터가 준비되면 콜백 호출
            }
        }
        
        
        
    }
}
    
