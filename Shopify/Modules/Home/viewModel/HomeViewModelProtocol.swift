//
//  HomeViewModelProtocol.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


protocol HomeViewModelProtocol{
    var brandsViewData: [BrandsViewData]! { get set }
    var fetchDataFromApi: FetchDataFromApi! { get }
    var bindBrandsToViewController : (()->())! { get set}
    func getBrandsFromNetworkService()
    func getCurrentCustomer() 
}
