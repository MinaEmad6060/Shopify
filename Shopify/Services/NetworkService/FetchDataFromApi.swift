//
//  FetchDataFromApi.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import Foundation
import Alamofire


class FetchDataFromApi{
        
        func formatUrl(baseUrl: String,request: String, query: String="", value: String="") -> String{
            return baseUrl+request+".json?"+query+"="+value
        }
        
        func getDataFromApi<T: Decodable>(url: String, handler: @escaping (T)->Void){
            let urlFB = URL(string: url)
            guard let urlFB = urlFB else{return}
            
            
            AF.request(urlFB).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let upcomingMatches):
                    handler(upcomingMatches)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }

    static func CreateDraft(product: Product, note: String, complication: @escaping (Int) -> Void) {
            let urlString = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/draft_orders.json" //"https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/draft_orders.json"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            let lineItem: [String: Any] = [
                "id": product.id ?? 0,
                "title": product.title ?? "",
                "quantity": 2,
                "price": product.variants?[0].price ?? "20",
                "sku": "\(product.id ?? 0),\((product.image?.src)!)"
            ]
            
            let customer: [String: Any] = [
                "id": Constants.customerId ?? 0,
                "default_address": ["default": true]
            ]
            
            let appliedDiscount: [String: Any] = [
                "description": "Custom discount",
                "value": "10.0",
                "title": "Custom",
                "amount": "10.00",
                "value_type": "fixed_amount"
            ]
            
            let draftOrder: [String: Any] = [
                "note": note,
                "line_items": [lineItem],
                "applied_discount": appliedDiscount,
                "customer": customer
            ]
            
            let userDictionary: [String: Any] = ["draft_order": draftOrder]
            
            urlRequest.httpShouldHandleCookies = false
            
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: userDictionary, options: .prettyPrinted)
                urlRequest.httpBody = bodyData
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("JSON serialization error: \(error.localizedDescription)")
                return
            }
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data, data.count > 0 {
                    do {
                        let draftResponse = try JSONDecoder().decode(Drafts.self, from: data)
                        if let draftOrderId = draftResponse.draftOrder?.id {
                            print("Draft Order ID: \(draftOrderId)")
                            
                            
                            if note == "cart" {
                                Constants.cartId = draftOrderId
//                                UserDefaults.standard.set(draftOrderId, forKey: "draftOrderIDCart")
                            } else if note == "favorite" {
                                Constants.favId = draftOrderId

//                                UserDefaults.standard.set(draftOrderId, forKey: "draftOrderIDFavorite")
                            }
                        } else {
                            print("Draft Order ID not found")
                        }
                    } catch {
                        print("JSON decoding error: \(error.localizedDescription)")
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        complication(httpResponse.statusCode)
                    }
                } else if let error = error {
                    print("HTTP request error: \(error.localizedDescription)")
                }
            }.resume()
        }
    

    static func postOrder(lineItems: [LineItemm], customer: [String: Any]){
        let url = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/orders.json"
        let accessToken = "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"

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": accessToken
        ]
        print("Post Order")

//        let customer: [String: Any] = [
//                "id": 7435246534827,
//                "currency": "EGP"
//            ]
        
        let order: [String: Any] = [
                "customer": customer,
                "line_items": lineItems.map { try! JSONSerialization.jsonObject(with: JSONEncoder().encode($0), options: []) }
            ]
            
        let parameters: [String: Any] = [
            "order": order
        ]
        
//        let parameters: [String: Any] = [
//            "order": [
//                "customer": [
//                    "id": 7435246534827,
//                    "currency": "EGP"
//                ],
//                "line_items": [
//                    [
//                        "title": "CONVERSE | CHUCK TAYLOR ALL STAR LO",
//                        "price": 100.00,
//                        "quantity": 2
//                    ],
//                    [
//                        "title": "VANS |AUTHENTIC | LO PRO | BURGANDY/WHITE",
//                        "price": 99.95,
//                        "quantity": 1
//                    ]
//                ]
//            ]
//        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Order.self) { response in
            switch response.result {
            case .success(let orderResponse):
                print("Post Order Succeeded: \(orderResponse)")
                let lineItem = LineItemm(
                    id: 1,
                    title: "Sample Product",
                    quantity: 2,
                    price: "30.00",
                    variant_id: nil,
                    variant_title: nil,
                    properties: [
                        LineItemm.Property(name: "Color", value: "Red"),
                        LineItemm.Property(name: "Size", value: "M")
                    ], product_id: 123
                )

                let lineItemsArray = [lineItem]

                NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDCartFromNote(), lineItems: lineItemsArray) { success in
                    if success {
                        print("success")
                    } else {
                        print("error")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
        
}
    



   
