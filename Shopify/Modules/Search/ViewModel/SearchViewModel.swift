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

       func getAllProduct() {
           let url = NetworkManager().formatUrl(request: "products")
           
           NetworkManager.getDataFromApi(url: url) { (brandProduct: BrandProduct) in
               if let products = brandProduct.products {
                   self.products = products
                   self.filteredProducts = products
               }
           }
       }

       func searchProducts(for searchText: String) {
           filteredProducts = searchText.isEmpty ? products : products.filter { $0.title?.range(of: searchText, options: .caseInsensitive) != nil }
       }
}
