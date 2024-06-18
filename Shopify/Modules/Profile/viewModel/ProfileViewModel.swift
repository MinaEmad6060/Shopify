//
//  ProfileViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 18/06/2024.
//

import Foundation


class ProfileViewModel: ProfileViewModelProtocol{
    var ordersViewData: [OrderViewData]!
    
    var fetchDataFromApi: FetchDataFromApi!
    
    var bindOrdersToViewController: (() -> ())!
    
    init(){
        fetchDataFromApi = FetchDataFromApi()
    }
    
    
    func getOrdersFromNetworkService() {
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders", query: "customer_id", value: "7435246534827")){[weak self] (complectedOrders: ComplectedOrder) in
                self?.ordersViewData = [OrderViewData]()
                for i in 0..<(complectedOrders.orders?.count ?? 0){
                    var order = OrderViewData()
                    order.id = complectedOrders.orders?[i].id
                    order.created_at = complectedOrders.orders?[i].created_at
                    order.first_name = complectedOrders.orders?[i].customer?.first_name
                    for j in 0..<(complectedOrders.orders?[i].line_items?.count ?? 0){
                        order.amount = complectedOrders.orders?[i].line_items?[j].price_set?.shop_money?.amount
                        order.currency_code = complectedOrders.orders?[i].line_items?[j].price_set?.shop_money?.currency_code
                        order.quantity = complectedOrders.orders?[i].line_items?[j].quantity
                        order.title = complectedOrders.orders?[i].line_items?[j].title
                    }
                    self?.ordersViewData.append(order)
                }
            
            
                self?.bindOrdersToViewController?()
            }
    }
    
    func getOrderDetailsFromNetworkService() {
        
    }
    
    
}
