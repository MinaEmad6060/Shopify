//
//  SearchViewModel.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import Foundation
class SearchViewModel{
     
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var bindFilteredProductsToViewController: (() -> ())!
    
    var fetchDataFromApi: FetchDataFromApi!
    
    init(){
        fetchDataFromApi = FetchDataFromApi()
    }
     
    func getAllProduct() {
        
        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl,request: "products") ?? ""){ (products: BrandProduct) in
              if let products = products.products {
                   self.products = products
                   self.filteredProducts = products
                   print("VM :: \(self.filteredProducts.count)")
                   self.bindFilteredProductsToViewController?()
              } else {
                  print("No products found")
              }
        }
        
        
      }

       func searchProducts(for searchText: String) {
           filteredProducts = searchText.isEmpty ? products : products.filter { $0.title?.range(of: searchText, options: .caseInsensitive) != nil }
          
       }

}
