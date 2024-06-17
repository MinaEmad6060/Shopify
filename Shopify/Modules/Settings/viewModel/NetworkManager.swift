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
        let url = "\(Constants.baseUrl)/products/\(productId).json"
        
        
        AF.request(url, method: .get).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let productResponse):
                completion(productResponse.product.variants.first?.inventoryQuantity)
            case .failure(let error):
                print("Error fetching product availability: \(error)")
                completion(nil)
            }
        }
    }
}

    struct ProductResponse: Codable {
        let product: Product
    }

    struct Product: Codable {
        let id: Int
        let variants: [Variant]
    }

struct Variant: Codable {
    let id: Int
    let inventoryQuantity: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case inventoryQuantity = "inventory_quantity"
    }
}

