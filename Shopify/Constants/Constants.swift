//
//  Constants.swift
//  Shopify
//
//  Created by Slsabel Hesham on 09/06/2024.
//

import Foundation

class Constants{
    static var api_key = "106ef29b5ab2d72aa0243decb0774101"
    static var password = "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"
    static var hostname = "mad44-alex-ios-team3.myshopify.com"
    static var baseUrl = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/"
//    static var orders: [OrderViewData]?
    
    static var categoryID: UInt64?
    
    static var orderId: UInt64?
    
    static var displayedLineItems: [LineItem]?
    
    static var cartId: Int?
    static var favId: Int?
    static var customerId: Int?
    
    static var categoryFilteredItems: [BrandProductViewData]?
    
    static func setSelectedCategory(category: String){
        print("Static :: \(category)")
        switch(category){
            case "WOMEN":
                categoryID = 304608936107
            case "KID":
                categoryID = 304608968875
            case "MEN":
                categoryID = 304608903339
            case "SALE":
                categoryID = 304609001643
            default: break
        }
    }
}
