//
//  Order.swift
//  Shopify
//
//  Created by Mina Emad on 13/06/2024.
//

import Foundation



struct ComplectedOrder:Decodable{
    var orders: [Order]?
}

struct Order: Decodable{
    var customer: Customer?
    var created_at: String?
    var line_items: [OrderDetails]?
}



struct Customer:Decodable{
    var id: UInt64?
    var first_name: String?
    var created_at: String?
}



struct OrderDetails:Decodable{
    var price_set: Price?
    var quantity: Int8?
    var title: String?
}



struct Price: Decodable{
    var shop_money: ShopPrice?
}


struct ShopPrice: Decodable{
    var amount: String?
    var currency_code: String?
}
