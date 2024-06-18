//
//  ProductInfoViewModel.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import Foundation
class ProdutInfoViewModel {
    var product : Product?
    init(product: Product?) {
        self.product = product
    }
    let draftOrderIDFavorite = Utilites.getDraftOrderIDFavorite()
    let draftOrderIDCart = Utilites.getDraftOrderIDCart()
    let customerId = Utilites.getCustomerID()
    func updateCartDraftOrder(product: Product){
        NetworkManager.updateDraftOrder(draftOrderId: draftOrderIDCart, product: product) { statusCode in
            if statusCode == 200 {
                print("Draft order updated successfully")
            } else {
                print("Failed to update draft order. Status code: \(statusCode)")
            }
        }
    }
}
