//
//  ProfileViewModelProtocol.swift
//  Shopify
//
//  Created by Mina Emad on 18/06/2024.
//

import Foundation


protocol ProfileViewModelProtocol{
    var ordersViewData: [OrderViewData]! { get set }
    var fetchDataFromApi: FetchDataFromApi! { get }
    var bindOrdersToViewController : (()->())! { get set}
    func getOrdersFromNetworkService()
    func getOrderDetailsFromNetworkService()
}
