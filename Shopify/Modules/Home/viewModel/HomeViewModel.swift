//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


class HomeViewModel: HomeViewModelProtocol{
    
//    var query: String!
//    var queryValue: String!
//    var brandImage: String!
//    var brandName: String!
    
    var brandsViewData: [BrandsViewData]!
    var fetchDataFromApi: FetchDataFromApi!
//    var brandProductsViewData: [BrandProductViewData]!

    var bindBrandsToViewController : (()->())! = {}
//    var bindBrandProductsToViewController : (()->())! = {}

    
    init(){
        brandsViewData = [BrandsViewData]()
//        brandProductsViewData = [BrandProductViewData]()
        fetchDataFromApi = FetchDataFromApi()
    }
    
    func getBrandsFromNetworkService(){
        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl, request: "smart_collections") ?? ""){[weak self] (brands: Brand) in
            var brand = BrandsViewData()
            for i in 0..<(brands.smart_collections?.count ?? 0){
                brand.id = brands.smart_collections?[i].id
                brand.image = brands.smart_collections?[i].image
                brand.title = brands.smart_collections?[i].title
                self?.brandsViewData.append(brand)
            }
            self?.bindBrandsToViewController?()
        }
    }
    
//    func getBrandProductsFromNetworkService(){
//        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: query, value: queryValue)){[weak self] (brandProducts: BrandProduct) in
//            var product = BrandProductViewData()
//            for i in 0..<(brandProducts.products?.count ?? 0){
//               
//                self?.brandProductsViewData.append(product)
//            }
//            self?.bindBrandProductsToViewController?()
//        }
//    }
}
