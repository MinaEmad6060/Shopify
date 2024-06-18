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
            
            guard let newUrl = url else {
                return
            }
            print(newUrl)
            var urlRequest = URLRequest(url: newUrl)
            urlRequest.httpMethod = "POST"
            let customerInfoDictionary = ["customer": ["first_name": newCustomer.first_name ?? "",
                                                       "last_name" : newCustomer.last_name ?? "",
                                                       "email": newCustomer.email ?? "",
                                                       "tags": newCustomer.tags ?? ""
                                                      ]]
            urlRequest.httpShouldHandleCookies = false
            do {
                let httpBodyDictionary = try JSONSerialization.data(withJSONObject: customerInfoDictionary, options: .prettyPrinted)
                urlRequest.httpBody = httpBodyDictionary
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch let error {
                print(error.localizedDescription)
            }
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data, data.count != 0 {
                    if let httpResponse = response as? HTTPURLResponse {
                        let responseString = String(data: data, encoding: .utf8)
                        print("**************")
                        print(responseString ?? "")
                        print("**************")
                        
                        do {
                            // Decode the response JSON to get the new customer details
                            let decodedResponse = try JSONDecoder().decode(CustomerResponse.self, from: data)
                            let updatedCustomer = decodedResponse.customer
                            
                            // Update newCustomer with the details from the response
                            newCustomer.id = updatedCustomer.id
                            newCustomer.first_name = updatedCustomer.first_name
                            newCustomer.last_name = updatedCustomer.last_name
                            newCustomer.email = updatedCustomer.email
                            newCustomer.tags = updatedCustomer.tags
                            newCustomer.note = updatedCustomer.note
                            newCustomer.created_at = updatedCustomer.created_at
                            
                            // Now you can print the updated customer details
                            print("customer.id: \(newCustomer.id ?? 0)")
                            print("customer.email: \(newCustomer.email ?? "")")
                            
                            UserDefaults.standard.set(newCustomer.id, forKey: "userID")
                            UserDefaults.standard.set(newCustomer.email, forKey: "userEmail")
                            
                            complication(httpResponse.statusCode)
                        } catch let decodeError {
                            print("Failed to decode response: \(decodeError.localizedDescription)")
                        }
                    }
                }
                
            }.resume()
        }
    }

