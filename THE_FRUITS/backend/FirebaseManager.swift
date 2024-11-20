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
    
    
    func fetchProductsForBrand(products: ObservableProducts) {//브랜드별 상품 목록 가지고 오기
        guard !sellerid.isEmpty else {
            print("Seller ID is empty. Cannot fetch products.")
            return
        }

        let db = Firestore.firestore()
        db.collection("products")
            .whereField("brandId", isEqualTo: sellerid) // 브랜드 ID로 필터링
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching products: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No products found for the brand")
                    return
                }

                let fetchedProducts = documents.compactMap { doc -> ProductItem? in
                    let data = doc.data()
                    guard
                        let id = data["id"] as? String,
                        let name = data["name"] as? String,
                        let price = data["price"] as? Int,
                        let imageUrl = data["imageUrl"] as? String
                    else {
                        return nil
                    }
                    return ProductItem(id: id, name: name, price: price, imageUrl: imageUrl)
                }

                DispatchQueue.main.async {
                    products.items = fetchedProducts // UI 업데이트를 위해 메인 스레드에서 실행
                }
            }
    }

    
}


