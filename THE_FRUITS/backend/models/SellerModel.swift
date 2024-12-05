//
//  SellerModel.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/21/24.
//

import FirebaseFirestore

struct Brand{ // used for seller home
    let name: String
    let logo: String
}

struct BrandModel: Codable, Identifiable{
    var id: String { brandid }
    var brandid: String
    var sellerid: String
    let info: String
    let name: String
    let logo: String
    let thumbnail: String
    let slogan: String
    let likes: Int
    let orders: [String]
    let createdAt: Timestamp
    let productid: [String]
    let account: String
    let bank: String
    let deliverycost: Int
    let sigtype: [String]?
    let phone: String
    let address: String
    let businessnum: String
    let notification: String//추가
    let purchase_notice: String
    let return_policy: String
    //let imageUrl:String
}

struct BrandEditModel: Codable{
    let brandid: String
    var name: String
    var logo: String
    var thumbnail: String
    var info: String
    var sigtype: [String]
    var bank: String
    var account: String
    var address: String
}

struct OrderModel: Codable, Identifiable{
    var id: String { orderid }
    let orderid: String
    let orderdate: String
    let brandid: String
    let products: [String]
    let totalprice: Int
    let delcost: Int
    let account: String
    let bank: String
    let sellername: String
    let customername: String
    let customerphone: String
    let recaddress: String
    let recname: String
    let recphone: String
    let state: Int
    let delnum: String
    let delname: String
    let ordernum: String
}


struct SellerModel: Codable{
    let sellerid: String
    let username: String
    let password: String
    let name: String
    let phone: String
    let brands: [String]
}

