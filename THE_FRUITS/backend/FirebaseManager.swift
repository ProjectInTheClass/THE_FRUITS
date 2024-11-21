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
    @Published var customer: CustomerModel?
    @Published var cart: CartModel?
    @Published var orderprod: [OrderProdModel] = []
    @Published var seller: SellerModel?
    
    //@Published var brand: BrandModel?
    
    let db = Firestore.firestore()
    
    
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
    
    func fetchOrderProd() async -> [OrderProdModel]? {
        guard let orderprodids = cart?.orderprodid else {
            
            print("No orderprodids found in cart")
            return nil
        }
    
        var fetchedOrderProd: [OrderProdModel] = []
        
        do {
            for orderprodid in orderprodids {
                
                let document = try await db.collection("orderprod").document(orderprodid).getDocument()
                
                
                // 데이터가 있는 경우 OrderProdModel로 디코딩
                if let data = document.data() {
                    let orderProd = try Firestore.Decoder().decode(OrderProdModel.self, from: data)
                    fetchedOrderProd.append(orderProd)
                } else {
                    print("No data found for orderprodid \(orderprodid)")
                }
            }
            // @Published 배열에 저장t
            DispatchQueue.main.async {
                self.orderprod = fetchedOrderProd
            }
            return fetchedOrderProd
        } catch {
            print("Error fetching orderprod data: \(error)")
            return nil
        }
    }
    
    func fetchBrand(brandId: String, completion: @escaping (BrandModel?) -> Void) {
        db.collection("brand").document(brandId).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let brand = try document.data(as: BrandModel.self)
                    completion(brand) // 성공적으로 데이터를 가져오면 반환
                } catch {
                    print("Error decoding document into BrandModel: \(error.localizedDescription)")
                    completion(nil) // 에러 발생 시 nil 반환
                }
            } else {
                print("Document does not exist")
                completion(nil) // 문서가 존재하지 않을 경우 nil 반환
            }
        }
    }
}


