//
//  AllProductsViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


class AllProductsViewModel: AllProductsViewModelProtocol{

    
    var brandProductsViewData: [BrandProductViewData]!
    var fetchDataFromApi: FetchDataFromApi!
    
    var query: String!
    var queryValue: String!
    var brandImage: String!
    var brandName: String!
    
    var bindBrandProductsToViewController: (() -> ())!
    init(){
        brandProductsViewData = [BrandProductViewData]()
        fetchDataFromApi = FetchDataFromApi()
        query = ""
        queryValue = ""
        brandImage = ""
        brandName = ""
    }
    
   
    func getBrandProductsFromNetworkService() {
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: query ?? "", value: queryValue ?? "")){[weak self] (brandProducts: BrandProduct) in
            for i in 0..<(brandProducts.products?.count ?? 0){
                var product = BrandProductViewData()
                product.id = brandProducts.products?[i].id
                product.title = brandProducts.products?[i].title
                product.body_html = brandProducts.products?[i].body_html
                product.product_type = brandProducts.products?[i].product_type
                product.price = brandProducts.products?[i].variants?[0].price
                for j in 0..<(brandProducts.products?[i].images?.count ?? 0){
                    product.src.append(brandProducts.products?[i].images?[j].src ?? "")
                }
                for j in 0..<(brandProducts.products?[i].options[0].values?.count ?? 0){
                    product.values.append(brandProducts.products?[i].options[0].values?[j] ?? "")
                }
                product.name = brandProducts.products?[i].options[0].name
                self?.brandProductsViewData.append(product)
            }
            
            self?.bindBrandProductsToViewController?()
        }
    }
   

}
