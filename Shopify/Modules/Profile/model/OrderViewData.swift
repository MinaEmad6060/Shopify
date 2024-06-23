//
//  OrderViewData.swift
//  Shopify
//
//  Created by Mina Emad on 18/06/2024.
//

import Foundation


struct OrderViewData {
    var id: UInt64?
    var created_at: String?
    var first_name: String?
    var amount: String?
    var currency_code: String?
    var total_price: String?
    var quantity: Int8?
    var title: String?
}

/**
 class Customer:Decodable{
     var id: Int?
     var first_name: String?
     var last_name: String?
     var email: String?
     var tags: String?
     var note: String?
     var created_at: String?
 }

 struct Order: Decodable{
     var id: UInt64?
     var customer: Customer?
     var created_at: String?
     var line_items: [OrderProduct]?
 }

 struct OrderDetails: Decodable{
     var order: Order?
 }

 struct OrderProduct:Decodable{
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
 */
