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
        
        static func createDraft(product: Product, note: String?, complication: @escaping (Int) -> Void) {
            let urlString = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/draft_orders.json"
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
                "price": product.variants?.first?.price ?? "20",
                "sku": "\(product.id ?? 0),\((product.images?[0]) )"
            ]
            
            
            
            let draftOrder: [String: Any] = [
                "note": note,
                "line_items": [lineItem],
                
                
            ]
            
            let userDictionary: [String: Any] = [
                "draft_order": draftOrder
            ]
            
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: userDictionary, options: .prettyPrinted)
                urlRequest.httpBody = bodyData
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error serializing JSON: \(error.localizedDescription)")
                return
            }
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print(responseString)
                    }
                    complication(httpResponse.statusCode)
                }
            }.resume()
        }
        
    }
    

   
