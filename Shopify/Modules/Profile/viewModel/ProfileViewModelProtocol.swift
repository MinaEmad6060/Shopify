//
//  ProfileViewModelProtocol.swift
//  Shopify
//
//  Created by Mina Emad on 18/06/2024.
//

import Foundation


protocol ProfileViewModelProtocol{
    var ordersViewData: [OrderViewData]! { get set }
    var orderDetailsViewData: [OrderDetailsViewData]! { get set }
    var basicOrderDetailsViewData: BasicDetailsOrderViewData! { get set }
    var fetchDataFromApi: FetchDataFromApi! { get }
    var bindOrdersToViewController : (()->())! { get set}
    var bindOrderDetailsToViewController : (()->())! { get set}
    func getOrdersFromNetworkService()
    func getOrderDetailsFromNetworkService()
}
