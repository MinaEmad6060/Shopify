//
//  CategoriesViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


class CategoriesViewModel: CategoriesViewModelProtocol{
    
    var categoriesViewData: [BrandProductViewData]!
    var fetchDataFromApi: FetchDataFromApi!
    var bindCategoriesToViewController: (() -> ())!
    
    init(){
        fetchDataFromApi = FetchDataFromApi()
    }
    
    func getCategoriesFromNetworkService() {
        categoriesViewData = [BrandProductViewData]()
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: "collection_id", value: "\(Constants.categoryID ?? 0)")){[weak self] (brandProducts: BrandProduct) in
            
            for i in 0..<(brandProducts.products?.count ?? 0){
                var product = BrandProductViewData()
                product.id  = brandProducts.products?[i].id
                product.title = brandProducts.products?[i].title
                product.body_html = brandProducts.products?[i].body_html
                product.product_type = brandProducts.products?[i].product_type
                product.price = brandProducts.products?[i].variants?[0].price
                product.inventory_quantity = brandProducts.products?[i].variants?[0].inventory_quantity
                for l in 0..<(brandProducts.products?[i].variants?.count ?? 0){
                    product.variants.append(brandProducts.products?[i].variants?[l].id ?? 0)
                    let variantQuantity = brandProducts.products?[i].variants?[l].inventory_quantity ?? 0
                    product.quantity.append(variantQuantity)
                }
                for j in 0..<(brandProducts.products?[i].images?.count ?? 0){
                    product.src.append(brandProducts.products?[i].images?[j].src ?? "")
                }
                for j in 0..<(brandProducts.products?[i].options[0].values?.count ?? 0){
                    product.sizes.append(brandProducts.products?[i].options[0].values?[j] ?? "")
                }
                for k in 0..<(brandProducts.products?[i].options[1].values?.count ?? 0){
                    product.colors.append(brandProducts.products?[i].options[1].values?[k] ?? "")
                }
                product.name = brandProducts.products?[i].options[0].name
                self?.categoriesViewData.append(product)
            }
            
            self?.bindCategoriesToViewController?()
        }
    }
    
    func removeProductFromDraftOrder(productTitle: String) {
        
        NetworkManager.removeLineItemFromDraftOrder(draftOrderId: Utilites.getDraftOrderIDFavoriteFromNote(), productTitle: productTitle) { statusCode in
            if statusCode == 200 {
                print("Product removed from draft order successfully")
            } else {
                print("Failed to remove product from draft order. Status code: \(statusCode)")
            }
        }
    }
    func isProductInDraftOrder(productTitle: String, completion: @escaping (Bool) -> Void) {
            let draftOrderIDFavorite = Utilites.getDraftOrderIDFavoriteFromNote()
            NetworkManager.fetchLineItemsInDraftOrder(draftOrderId: draftOrderIDFavorite) { lineItems in
                if let lineItems = lineItems {
                    let isInDraftOrder = lineItems.contains { $0.title == productTitle }
                    completion(isInDraftOrder)
                } else {
                    completion(false)
                }
            }
        }
    func updateFavoriteDraftOrder(product: BrandProductViewData){
        NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDFavoriteFromNote() , product: product) { statusCode in
            if statusCode == 200 {
                print("Draft order updated successfully")
            } else {
                print("Failed to update draft order. Status code: \(statusCode)")
            }
        }}
}
