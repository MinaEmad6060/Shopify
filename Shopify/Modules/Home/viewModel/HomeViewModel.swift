//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


class HomeViewModel: HomeViewModelProtocol{
    var brandsViewData: [BrandsViewData]!
    var fetchDataFromApi: FetchDataFromApi!

    var bindBrandsToViewController : (()->())! = {}
    var brands: [SmartCollection]!

    
    init(){
        brandsViewData = [BrandsViewData]()
        fetchDataFromApi = FetchDataFromApi()
        brands = [SmartCollection]()
    }
    
    func getBrandsFromNetworkService(){
        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl, request: "smart_collections") ?? ""){[weak self] (brands: Brand) in
            print("url :: \(self?.fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl, request: "smart_collections") ?? "")")
            self?.brands = brands.smart_collections
            var brand = BrandsViewData()
            for i in 0..<(self?.brands.count ?? 0){
                brand.id = self?.brands[i].id
                brand.image = self?.brands[i].image
                brand.title = self?.brands[i].title
                self?.brandsViewData.append(brand)
            }
            self?.bindBrandsToViewController?()
        }
    }
}
