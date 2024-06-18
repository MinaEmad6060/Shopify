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
    
    
    /**
     var id: Int64?
     var title: String?
     var body_html: String?
     var product_type: String?
     var price: String?
     var src: String?
     var name: String?
     var values: [String]?
     */
    func getBrandProductsFromNetworkService() {
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: query ?? "", value: queryValue ?? "")){[weak self] (brandProducts: BrandProduct) in
            print("url :: \(self?.fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: self?.query ?? "") ?? "")")
            var product = BrandProductViewData()
            for i in 0..<(brandProducts.products?.count ?? 0){
                product.id = brandProducts.products?[i].id
                product.title = brandProducts.products?[i].title
                product.body_html = brandProducts.products?[i].body_html
                product.product_type = brandProducts.products?[i].product_type
                product.price = brandProducts.products?[i].variants?[0].price
                product.src = brandProducts.products?[i].images?[0].src
                product.name = brandProducts.products?[i].options[0].name
                product.values = brandProducts.products?[i].options[0].values
                self?.brandProductsViewData.append(product)
            }
            self?.bindBrandProductsToViewController?()
        }
    }
   

}
