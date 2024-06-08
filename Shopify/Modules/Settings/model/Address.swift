//
//  Address.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import Foundation

struct Address: Codable {
    let country: String
    let city: String
    let address: String
    let phone: String
}

struct CustomerAddressRequest: Codable {
    let address: Address
}
