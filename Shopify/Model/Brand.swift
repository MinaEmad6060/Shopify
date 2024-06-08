//
//  Brand.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import Foundation

//Brands
struct Brand: Decodable{
    var smart_collections: [SmartCollection]?
}

struct SmartCollection: Decodable{
    var id: Int64?
    var title: String?
    var image: ImageOfBrand?
}

struct ImageOfBrand: Decodable{
    var src: String?
}
