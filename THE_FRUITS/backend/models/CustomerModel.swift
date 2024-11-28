//
//  CustomerModel.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/19/24.
//

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
    let productid: String
}

struct OrderProdModel: Codable {
    let orderprodid: String
    let products: [OrderProductsModel]
    let selected: Bool
}


struct ProductModel: Codable, Identifiable {
    var productid: String
    var prodtitle: String
    var price: Int
    var info: String
    var imageUrl: String
    var type: String
    var soldout: Bool
    var id: String { productid }
}

struct OrderSummary {
    var orderprodid: String
    var products: [ProductDetail]
    var selected: Bool
}

struct ProductDetail {
    var productid: String
    var productName: String
    var price: Int
    var num: Int
}

