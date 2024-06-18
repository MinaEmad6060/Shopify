//
//  HomeViewModelProtocol.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


protocol HomeViewModelProtocol{
    var brandsViewData: [BrandsViewData]! { get set }
//    var brandProductsViewData: [BrandProductViewData]! { get set }
    var fetchDataFromApi: FetchDataFromApi! { get }
    var bindBrandsToViewController : (()->())! { get set}
//    var bindBrandProductsToViewController : (()->())! { get set}
    func getBrandsFromNetworkService()
//    func getBrandProductsFromNetworkService()
//    var query: String! { get set }
//    var queryValue: String! { get set }
//    var brandImage: String! { get set }
//    var brandName: String! { get set }
}
