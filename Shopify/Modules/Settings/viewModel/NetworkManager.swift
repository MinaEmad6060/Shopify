//
//  NetworkManager.swift
//  Shopify
//
//  Created by Slsabel Hesham on 09/06/2024.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var baseUrl = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/customers/177564125/addresses.json"
    //smart_collections.json
    func formatUrl(request: String, query: String="", value: String="") -> String{
        return baseUrl+request+".json?"+query+"="+value
    }
    
    static func getDataFromApi<T: Decodable>(url: String, handler: @escaping (T)->Void){
        let urlFB = URL(string: url)
        guard let urlFB = urlFB else{return}
        
        
        AF.request(urlFB).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                handler(result)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    static func addNewAddress(customerID: Int, address: Address, completion: @escaping (Bool) -> Void) {
        let url = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/customers/\(customerID)/addresses.json"
        
        let customerAddressRequest = CustomerAddressRequest(address: address)
        
        guard let encodedCredentials = "\(Constants.api_key):\(Constants.password)".data(using: .utf8)?.base64EncodedString() else {
            print("Failed to encode credentials")
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(encodedCredentials)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: customerAddressRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error adding address: \(error)")
                    completion(false)
                }
            }
    }
    static func deleteCustomerAddress(customerId: Int, addressId: Int, completion: @escaping (Bool) -> Void) {
        let url = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/customers/\(customerId)/addresses/\(addressId).json"
        
        AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error deleting address: \(error)")
                    completion(false)
                }
            }
    }
    
    static func updateDraftOrder(draftOrderId: Int, lineItems: [LineItem], completion: @escaping (Bool) -> Void) {
        let url = "\(Constants.baseUrl)/draft_orders/\(draftOrderId).json"
        guard let encodedCredentials = "\(Constants.api_key):\(Constants.password)".data(using: .utf8)?.base64EncodedString() else {
            print("Failed to encode credentials")
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(encodedCredentials)",
            "Content-Type": "application/json"
        ]
        
        let lineItemsData = lineItems.map { ["id": $0.id, "quantity": $0.quantity] }
        let parameters: [String: Any] = [
            "draft_order": [
                "line_items": lineItemsData
            ]
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("\(error)")
                completion(false)
            }
        }
    }
    static func fetchDraftOrder(draftOrderId: Int, completion: @escaping (DraftOrder?) -> Void) {
        let url = "\(Constants.baseUrl)draft_orders/\(draftOrderId).json"
        
        
        AF.request(url, method: .get).responseDecodable(of: DraftOrderResponse.self) { response in
            switch response.result {
            case .success(let draftOrderResponse):
                completion(draftOrderResponse.draft_order)
            case .failure(let error):
                print("Error fetching draft order: \(error)")
                completion(nil)
            }
        }
    }
    static func checkProductAvailability(productId: Int, completion: @escaping (Int?) -> Void) {
        let url = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/products/8100172759211.json"
        
        
        AF.request(url, method: .get).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let productResponse):
                completion(productResponse.product.variants?.first?.inventory_quantity)
            case .failure(let error):
                print("Error fetching product availability: \(error)")
                completion(nil)
            }
        }
    }
}

