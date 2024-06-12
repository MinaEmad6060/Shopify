//
//  SignUpNetworkServie.swift
//  Shopify
//
//  Created by maha on 12/06/2024.
//

import Foundation

class SignUpNetworkService {
    
    static func customerRegister(newCustomer: Customer, complication: @escaping (Int) -> Void) {
        
        let url = URL(string: "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04//customers.json")
        guard let newUrl = url else {
            return
        }
        print(newUrl)
        var urlRequest = URLRequest(url: newUrl)
        urlRequest.httpMethod = "POST"
        let customerInfoDictionary = ["customer": ["first_name": newCustomer.first_name,
                                           "last_name" : newCustomer.last_name,
                                           "email": newCustomer.email,
                                           "note": newCustomer.tags
                                          ]]
        urlRequest.httpShouldHandleCookies = false
        do {
            
            let httpBodyDictionary = try JSONSerialization.data(withJSONObject: customerInfoDictionary,options: .prettyPrinted)
            urlRequest.httpBody = httpBodyDictionary
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch let error {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if (data != nil && data?.count != 0){
                if let httpResponse = response as? HTTPURLResponse {
                    let response = String(data:data ?? Data(),encoding: .utf8)
                    complication(httpResponse.statusCode)
                    
                   }
            }
            
        }.resume()
    }
    
}
