//
//  Address.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import Foundation

struct Address: Codable {
    var id: Int?
    let address1: String?
    let city: String
    let country: String
    let phone: String

    enum CodingKeys: String, CodingKey {
        case id
        case address1
        case city
        case country
        case phone
    }
}
struct AddressResponse: Codable {
    let addresses: [Address]
}

struct CustomerAddressRequest: Codable {
    let address: Address
}
