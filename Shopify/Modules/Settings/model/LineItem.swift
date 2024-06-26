//
//  LineItem.swift
//  Shopify
//
//  Created by Slsabel Hesham on 14/06/2024.
//

import Foundation

struct DraftOrderResponsee: Codable {
    let draft_order: DraftOrderr

    enum CodingKeys: String, CodingKey {
        case draft_order = "draft_order"
    }
}

struct DraftOrderr: Codable {
    let id: Int
    var lineItems: [LineItemm]

    enum CodingKeys: String, CodingKey {
        case id
        case lineItems = "line_items"
    }
}

struct LineItemm: Codable {
    let id: Int
    let product_id: Int
    let title: String
    var quantity: Int
    let price: String
    let variant_id: Int?
    let variant_title: String?
    let properties: [Property]?
    let product_id: Int?
    
    struct Property: Codable {
        let name: String
        let value: String
    }
}



struct ProductResponse: Decodable {
    let product: Product
}
