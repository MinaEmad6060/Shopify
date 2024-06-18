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
    static func updateCustomerNote(customerId: Int, newNote: String, completion: @escaping (Int) -> Void) {
            let url = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/customers/\(customerId).json"
            
            let customerInfoDictionary: [String: Any] = ["customer": ["id": customerId, "note": newNote]]
            
            AF.request(url, method: .put, parameters: customerInfoDictionary, encoding: JSONEncoding.prettyPrinted, headers: ["Content-Type": "application/json"]).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let httpResponse = response.response {
                        do {
                            let decodedResponse = try JSONDecoder().decode(CustomerResponse.self, from: response.data!)
                            let updatedCustomer = decodedResponse.customer
                            
                            // Update UserDefaults based on the note
                            if updatedCustomer.note == "cart" {
                                UserDefaults.standard.set(updatedCustomer.id, forKey: "draftOrderIDCart")
                            } else if updatedCustomer.note == "favorite" {
                                UserDefaults.standard.set(updatedCustomer.id, forKey: "draftOrderIDFavorite")
                            }
                            
                            completion(httpResponse.statusCode)
                        } catch let decodeError {
                            print("Failed to decode response: \(decodeError.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Network request failed: \(error.localizedDescription)")
                    completion(-1)
                }
            }
        }
}
