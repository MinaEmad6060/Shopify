//
//  Address.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import Foundation

struct Address: Codable {
    
    let address1: String?
    let city: String
    let country: String
    let phone: String

    enum CodingKeys: String, CodingKey {
       
        case address1
        case city
        case country
        case phone
    }
}

struct AddressId: Codable {
    let id: Int?
    let address1: String?
    let city: String
    let country_name: String?
    let phone: String
    var `default`: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case address1
        case city
        case country_name
        case phone
        case `default`
    }
}
struct AddressResponse: Codable {
    let addresses: [AddressId]
}

struct CustomerAddressRequest: Codable {
    let address: Address
}
