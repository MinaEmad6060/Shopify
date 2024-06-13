//
//  Login.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import Foundation
class LoginedCustomers :Decodable{
    let customers: [Customer]
}
class Customer:Decodable{
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var tags: String?
    var note: String?
    var created_at: String?
}
