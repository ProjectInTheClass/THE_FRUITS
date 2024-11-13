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
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    /*init() {
        fetchData()
    }*/
    func fetchData() {
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
            let collection = userType == "customer" ? "costumer" : "seller"
            let db = Firestore.firestore()
            db.collection(collection).document(userId).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    self.name = data?["name"] as? String ?? ""
                    self.username = data?["username"] as? String ?? ""
                    self.password = data?["password"] as? String ?? ""
                } else {
                    print("Document does not exist")
                }
            }
        }
}


