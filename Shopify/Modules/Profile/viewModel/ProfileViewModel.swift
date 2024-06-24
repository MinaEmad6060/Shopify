//
//  ProfileViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 18/06/2024.
//

import Foundation


class ProfileViewModel: ProfileViewModelProtocol{
    var basicOrderDetailsViewData: BasicDetailsOrderViewData!
    
    var orderDetailsViewData: [OrderDetailsViewData]!
    
    var bindOrderDetailsToViewController: (() -> ())!
    
    var ordersViewData: [OrderViewData]!
    
    var fetchDataFromApi: FetchDataFromApi!
    
    var bindOrdersToViewController: (() -> ())!
    
    init(){
        fetchDataFromApi = FetchDataFromApi()
    }
    
    
    func getOrdersFromNetworkService() {
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders", query: "customer_id", value: "\(Utilites.getCustomerID())")){[weak self] (complectedOrders: ComplectedOrder) in
                self?.ordersViewData = [OrderViewData]()
                for i in 0..<(complectedOrders.orders?.count ?? 0){
                    var order = OrderViewData()
                    order.id = complectedOrders.orders?[i].id
                    order.created_at = complectedOrders.orders?[i].created_at
                    order.first_name = complectedOrders.orders?[i].customer?.first_name
                    order.total_price = complectedOrders.orders?[i].current_subtotal_price
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
        orderDetailsViewData = [OrderDetailsViewData]()
        basicOrderDetailsViewData = BasicDetailsOrderViewData()
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders/\(Constants.orderId ?? 0)")){[weak self] (orderDetails: OrderDetails) in
            print("URL :: \(self?.fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders/\(Constants.orderId ?? 0)") ?? "none")")
            self?.basicOrderDetailsViewData.first_name = orderDetails.order?.customer?.first_name
            self?.basicOrderDetailsViewData.created_at = orderDetails.order?.created_at
            self?.basicOrderDetailsViewData.orderId = orderDetails.order?.id
            
            for i in 0..<(orderDetails.order?.line_items?.count ?? 0){
                var product = OrderDetailsViewData()
                product.title = orderDetails.order?.line_items?[i].title
                product.amount = orderDetails.order?.line_items?[i].price_set?.shop_money?.amount
                product.currency_code = orderDetails.order?.line_items?[i].price_set?.shop_money?.currency_code
                product.quantity = orderDetails.order?.line_items?[i].quantity
//                product.amount = orderDetails.order?.line_items?[i].price_set?.shop_money?.amount
//                product.amount = orderDetails.order?.line_items?[i].price_set?.shop_money?.amount

                self?.orderDetailsViewData.append(product)
            }
            
            self?.bindOrderDetailsToViewController?()
        }
    }
    
    
}
