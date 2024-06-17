//
//  LineItem.swift
//  Shopify
//
//  Created by Slsabel Hesham on 14/06/2024.
//

import Foundation

struct DraftOrderResponse: Codable {
    let draft_order: DraftOrder

    enum CodingKeys: String, CodingKey {
        case draft_order = "draft_order"
    }
}

struct DraftOrder: Codable {
    let id: Int
    let lineItems: [LineItem]

    enum CodingKeys: String, CodingKey {
        case id
        case lineItems = "line_items"
    }
}

struct LineItem: Codable {
    let id: Int
    let name: String
    var quantity: Int
    let price: String
}

struct ProductResponse: Decodable {
    let product: Product
}
