//
//  SignUpNetworkServie.swift
//  Shopify
//
//  Created by maha on 12/06/2024.
//

import Foundation

class SignUpNetworkService {
    
    static func customerRegister(newCustomer: Customer, complication: @escaping (Int) -> Void) {
        
        let url = URL(string: "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/customers.json")
        //
        guard let newUrl = url else {
            return
        }
        print(newUrl)
        var urlRequest = URLRequest(url: newUrl)
        urlRequest.httpMethod = "POST"
        let customerInfoDictionary = ["customer": ["first_name": newCustomer.first_name,
                                           "last_name" : newCustomer.last_name,
                                           "email": newCustomer.email,
                                           "tags": newCustomer.tags
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
  
//    static func customerRegister(newCustomer: Customer, completion: @escaping (Customer?, Int) -> Void) {
//            
//            let url = URL(string: "https://mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/customers.json")
//            guard let newUrl = url else {
//                return
//            }
//            
//            var urlRequest = URLRequest(url: newUrl)
//            urlRequest.httpMethod = "POST"
//            let customerInfoDictionary: [String: Any] = ["customer": ["first_name": newCustomer.first_name ?? "",
//                                                                      "last_name": newCustomer.last_name ?? "",
//                                                                      "email": newCustomer.email ?? "",
//                                                                      "tags": newCustomer.tags ?? ""]]
//            
//            urlRequest.httpShouldHandleCookies = false
//            do {
//                let httpBody = try JSONSerialization.data(withJSONObject: customerInfoDictionary, options: .prettyPrinted)
//                urlRequest.httpBody = httpBody
//                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            } catch let error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//                if let httpResponse = response as? HTTPURLResponse {
//                    if let data = data, httpResponse.statusCode == 201 {
//                        do {
//                            let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                            if let customerData = responseDict?["customer"] as? [String: Any],
//                               let jsonData = try? JSONSerialization.data(withJSONObject: customerData),
//                               let customer = try? JSONDecoder().decode(Customer.self, from: jsonData) {
//                                completion(customer, httpResponse.statusCode)
//                            } else {
//                                completion(nil, httpResponse.statusCode)
//                            }
//                        } catch {
//                            print("Error decoding customer data: \(error)")
//                            completion(nil, httpResponse.statusCode)
//                        }
//                    } else {
//                        completion(nil, httpResponse.statusCode)
//                    }
//                }
//            }.resume()
//        }
}
