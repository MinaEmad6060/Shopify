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
    var body_html: String?
    var product_type: String?
    var variants: [Variant]?
    var images: [ImageOfBrand]?
    var options:[Options]
}

struct Variant: Decodable{
    let id: Int
    let inventory_quantity: Int
    var price: String?
}
struct Options: Decodable{
    var name: String?
    var values: [String]?
}
