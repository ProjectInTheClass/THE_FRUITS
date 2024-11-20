//
//  CustomerModel.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/19/24.
//

import FirebaseFirestore


struct CustomerModel: Codable {
    let address: String
    let cartid: String
    let customerid: String
    let likebrand: [String]
    let password: String
    let phone: String
    let username: String
    let name: String
}

struct CartModel: Codable {
    let cartid: String
    let orderprodid: [String]
    let brandid: String
}

struct OrderProductsModel: Codable {
    let num: Int
    let productid: DocumentReference
}

struct OrderProdModel: Codable {
    let orderprodid: String
    let products: [OrderProductsModel]
    let selected: Bool
}


struct ProductModel: Codable {
    let productid: String
    let prodtitle: String
    let price: Int
    let info: String
}
