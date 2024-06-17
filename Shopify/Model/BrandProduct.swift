//
//  Product.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import Foundation


struct BrandProduct: Decodable{
    var products: [Product]?
}



struct Product: Decodable{
    var id: Int64?
    var title: String?
    var product_type: String?
    var variants: [Variant]?
    var images: [ImageOfBrand]?
}

struct Variant: Decodable{
    let id: Int
    let inventory_quantity: Int
    var price: String?
}
