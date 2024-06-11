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
    let id: Int?
    let email: String?
    let tags: String?
}
