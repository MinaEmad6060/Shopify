//
//  ProductInfoViewModel.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import Foundation
class ProdutInfoViewModel {
    
    var product : BrandProductViewData?
    var customerId: Int
    var  draftOrderIDFavorite: Int?
    
    var draftOrderIDCart: Int?
    
    
    
    var fetchDataFromApi: FetchDataFromApi!
    
    init(){
        fetchDataFromApi = FetchDataFromApi()
        customerId = 0
        draftOrderIDFavorite = 0
        draftOrderIDCart = 0
    }
    
    //init(product: Product?) {
    
    //  var product : BrandProductViewData?
    init(product: BrandProductViewData?) {
        self.product = product
        self.customerId = Utilites.getCustomerID()
        
    }
    
    func updateCartDraftOrder(product: BrandProductViewData){
        let cartId = Utilites.getDraftOrderIDCartFromNote()
        print("sssssss\(cartId)")
        NetworkManager.updateDraftOrder(draftOrderId: cartId, product: product) { statusCode in
            if statusCode == 200 {
                print("Draft order updated successfully")
            } else {
                print("Failed to update draft order. Status code: \(statusCode)")
            }
        }}
    func updateFavoriteDraftOrder(product: BrandProductViewData){
        NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDFavoriteFromNote() , product: product) { statusCode in
            if statusCode == 200 {
                print("Draft order updated successfully")
            } else {
                print("Failed to update draft order. Status code: \(statusCode)")
            }
        }}
    
    
    
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
    
}
