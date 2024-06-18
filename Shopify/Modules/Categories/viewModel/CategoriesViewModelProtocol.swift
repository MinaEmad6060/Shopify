//
//  CategoriesViewModelProtocol.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


protocol CategoriesViewModelProtocol{
    var categoriesViewData: [CategoriesProductViewData]! { get set }
    var fetchDataFromApi: FetchDataFromApi! { get }
    var bindCategoriesToViewController : (()->())! { get set}
    func getCategoriesFromNetworkService()
}
