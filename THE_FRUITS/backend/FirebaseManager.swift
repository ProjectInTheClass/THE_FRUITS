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
    @Published var customerid: String = ""
    @Published var customer: CustomerModel?
    @Published var cart: CartModel?
    @Published var orderprod: [OrderProdModel] = []
    @Published var seller: SellerModel?

    
    /*init() {
     fetchData()
     }*/
    
    let db = Firestore.firestore()
    
    func fetchData() { // firebase test with specific user
        //let db = Firestore.firestore()
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

        db.collection(collection).document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if userType == "seller" { // store sellerid if it is seller
                    self.sellerid = data?["sellerid"] as? String ?? ""
                    print("sellerid in fetch: ", self.sellerid)
                    self.fetchSeller()
                }
                else if userType == "customer"{
                    self.customerid = data?["customerid"] as? String ?? ""
                    print("customerid in fetch: ", self.customerid)
                    self.fetchCustomer()
                }
                self.name = data?["name"] as? String ?? ""
                self.username = data?["username"] as? String ?? ""
                self.password = data?["password"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    //로그인 확인
    func validateLogin(userType: String, userId: String, completion: @escaping (Bool) -> Void) {
        let collection = userType == "customer" ? "customer" : "seller"
        let db = Firestore.firestore()
        
        // Firestore에서 해당 uid가 존재하는지 확인
        db.collection(collection).document(userId).getDocument { (document, error) in
            if let error = error {
                print("Error validating login: \(error.localizedDescription)")
                completion(false)
            } else if let document = document, document.exists {
                // uid가 해당 컬렉션에 존재
                print("\(userType) with uid \(userId) is valid.")
                completion(true)
            } else {
                // uid가 해당 컬렉션에 없음
                print("Error: \(userType) with uid \(userId) does not exist in the \(collection) collection.")
                completion(false)
            }
        }
    }

    
    // fetch customer data
    func fetchCustomer() {
        db.collection("customer").document(self.customerid).getDocument{ (document, error) in
//            if let error = error {
//                print("Error fetching customer data document")
//                return
//            }
           if let document = document, document.exists {
               do {
                   let customer = try document.data(as: CustomerModel.self)
                   self.customer = customer
                    //print("Customer Data: \(customer)")
               } catch {
                   //print("Error decoding document into CustomerModel: \(error.localizedDescription)")
                   print("error decoding document into CustomerModel")
               }
           } else {
               print("Document does not exist")
           }
        }
    }
    func fetchSeller(){
        db.collection("seller").document(self.sellerid).getDocument{ (document, error) in
//            if let error = error {
//                print("Error fetching customer data document")
//                return
//            }
           if let document = document, document.exists {
               do {
                   let seller = try document.data(as: SellerModel.self)
                   self.seller = seller
                   print("seller brand ids \(seller.brands)")
                    //print("Customer Data: \(customer)")
               } catch {
                   //print("Error decoding document into CustomerModel: \(error.localizedDescription)")
                   print("error decoding document into SellerModel")
               }
           } else {
               print("Document does not exist")
           }
        }
    }
    
    func fetchCart(userId: String) async {
        do{
            let cartDocuments = try await db.collection("customer").document(userId).collection("cart").getDocuments()
            
            guard let document = cartDocuments.documents.first else {
                print("No cart documents found")
                return
            }
            let cart = try document.data(as: CartModel.self)
            self.cart = cart
                        
        } catch {
            print("fetch cart error")
            
        }
    }
    
    /* storeName으로 브랜드테이블에 접근*/
    func fetchProductIdsForBrand(storeName: String, completion: @escaping ([String]) -> Void) {
        //let db = Firestore.firestore()
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
                
                let document = documents[0]//혹시나 중복될 경우를 윟
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
        //let db = Firestore.firestore()
        var fetchedProducts: [ProductItem] = []
        let dispatchGroup = DispatchGroup() // 동기 처리를 위해 DispatchGroup 사용
        
        for productid in productids {
            dispatchGroup.enter()
            db.collection("product").document(productid).getDocument { document, error in
                if let error = error {
                    print("Error fetching product \(productid): \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    //print("Fetched product document for ID \(productid): \(document.data() ?? [:])")
                    if let data = document.data(), let price = data["price"] as? Int {
                        print("Price: \(price)")
                    } else {
                        print("Price not found or invalid")
                    }
                    
                    if let data = document.data() {
                        guard let id = data["productid"] as? String else {
                            //print("Product ID is missing for document \(document.documentID)")
                            dispatchGroup.leave()
                            return
                        }
                        let name = data["info"] as? String ?? "No Info"
                        let price = data["price"] as? Int ?? 0
                        let imageUrl = data["imageUrl"] as? String ?? "https://default-image-url.com/default.jpg"
                        
                        //print("Creating ProductItem with id: \(id), name: \(name), price: \(price), imageUrl: \(imageUrl)")
                        let product = ProductItem(id: id, name: name, price: price, imageUrl: imageUrl)
                        fetchedProducts.append(product)
                    } else {
                        print("No data found for document \(productid)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                //print("Final fetched products: \(fetchedProducts)")
                completion(fetchedProducts) // 모든 데이터가 준비되면 콜백 호출
            }
        }
        
    }
    
    func fetchBrandIDs(completion: @escaping ([String]) -> Void) {
        db.collection("brand").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching brand IDs: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents found in the 'brand' collection")
                completion([])
                return
            }

            // 문서 ID만 가져오기
            let brandIDs = documents.map { $0.documentID }
            print("Fetched brand IDs: \(brandIDs)")
            completion(brandIDs)
        }
    }

    
    func fetchBrand(brandid: String, completion: @escaping (BrandModel?) -> Void) {
        print("브랜드 Id params으로=>", brandid) // 잘 받아옴

        db.collection("brand").document(brandid).getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let document = document, let data = document.data() else {
                print("Document does not exist or contains no data")
                completion(nil)
                return
            }

            print("Fetched raw data: \(data)") // 디버깅용 출력

            do {
                let brand = try document.data(as: BrandModel.self)
                completion(brand)
            } catch {
                print("Error decoding document into BrandModel: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func uploadCartItems(storeName: String, cartItems: [[String: Any]], completion: @escaping (Result<Void, Error>) -> Void) {
            let collectionRef = db.collection("orderprod")
            collectionRef.addDocument(data: [
                //"storeName": storeName,
                "pruducts": cartItems,
                "selected": false
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }

}
    
