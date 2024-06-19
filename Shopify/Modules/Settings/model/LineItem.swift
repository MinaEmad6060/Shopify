//
//  LineItem.swift
//  Shopify
//
//  Created by Slsabel Hesham on 14/06/2024.
//

import Foundation

struct DraftOrderResponse: Codable {
    let draft_order: Drafts

    enum CodingKeys: String, CodingKey {
        case draft_order = "draft_order"
    }
}


/*
struct LineItem: Codable {
    let id: Int
    let name: String
    var quantity: Int
    let price: String
    let variant_id: String?
    let variant_title: String?
}
*/

struct ProductResponse: Decodable {
    let product: Product
}
