//
//  FetchDataFromApi.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import Foundation
import Alamofire


class FetchDataFromApi{
    
    var baseUrl = ""
    
    func getSportData(url: String, handler: @escaping (Brand)->Void){
        let urlFB = URL(string: url)
        guard let urlFB = urlFB else{return}
        
        
        AF.request(urlFB).responseDecodable(of: Brand.self) { response in
            switch response.result {
            case .success(let upcomingMatches):
                handler(upcomingMatches)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
