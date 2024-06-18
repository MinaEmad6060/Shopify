//
//  AllProductsViewModelProtocol.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


protocol AllProductsViewModelProtocol{
    var brandProductsViewData: [BrandProductViewData]! { get set }
    var fetchDataFromApi: FetchDataFromApi! { get }
    var bindBrandProductsToViewController : (()->())! { get set}
    func getBrandProductsFromNetworkService()
    var query: String! { get set }
    var queryValue: String! { get set }
    var brandImage: String! { get set }
    var brandName: String! { get set }
}
