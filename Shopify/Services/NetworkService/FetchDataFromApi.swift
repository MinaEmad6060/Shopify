//
//  FetchDataFromApi.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import Foundation
import Alamofire


class FetchDataFromApi{
    
    var baseUrl = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/"
    //smart_collections.json
    func formatUrl(request: String, query: String="", value: String="") -> String{
        return baseUrl+request+".json?"+query+"="+value
    }
    
    func getSportData<T: Decodable>(url: String, handler: @escaping (T)->Void){
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
    
}
