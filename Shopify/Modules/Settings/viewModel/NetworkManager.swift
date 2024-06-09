//
//  NetworkManager.swift
//  Shopify
//
//  Created by Slsabel Hesham on 09/06/2024.
//

import Foundation
import Alamofire

class NetworkManager{
    
    static func addNewAddress(customerID: Int, address: Address) {
        let url = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/customers/\(customerID)/addresses.json"
        
        let customerAddressRequest = CustomerAddressRequest(address: address)
        
        
        guard let encodedCredentials = "\(Constants.api_key):\(Constants.password)".data(using: .utf8)?.base64EncodedString() else {
            print("Failed to encode credentials")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(encodedCredentials)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: customerAddressRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Response JSON: \(value)")
                case .failure(let error):
                    print("Error adding address: \(error)")
                }
            }
    }
}
