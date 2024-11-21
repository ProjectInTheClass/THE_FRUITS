//
//  SellerModel.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/21/24.
//

import FirebaseFirestore

struct BrandModel: Codable {
    let brandid: String
    let sellerid: String
    let info: String
    let name: String
    let logo: String
    let thumbnail: String
    let slogan: String
    let likes: Int
    let orders: [String]
    //let ordernum: Int
    let createdAt: Timestamp
    let productid: [String]
    let account: String
    let bank: String
    let deliverycost: Int
    let sigtype: [String]
    let phone: String
    let address: String
    let businessnum: String
    let notification: String
    let purchase_notice: String
    let return_policy: String
}

struct SellerModel: Codable{
    let sellerid: String
    let username: String
    let password: String
    let name: String
    let phone: String
    let brands: [String]
}
