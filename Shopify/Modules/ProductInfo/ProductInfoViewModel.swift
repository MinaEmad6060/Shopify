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
       // getCurrentCustomer()
    
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
        guard let draftOrderIDFavorite = draftOrderIDFavorite else {
            print("Cart draft order ID is not available")
            return
        }
        
        NetworkManager.removeLineItemFromDraftOrder(draftOrderId: draftOrderIDFavorite, productTitle: productTitle) { statusCode in
            if statusCode == 200 {
                print("Product removed from draft order successfully")
            } else {
                print("Failed to remove product from draft order. Status code: \(statusCode)")
            }
        }
    }
    //968066891947
    func isProductInDraftOrder(productTitle: String, completion: @escaping (Bool) -> Void) {
        let draftOrderIDFavorite = Utilites.getDraftOrderIDFavorite()

        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl,request: "draft_orders/\(draftOrderIDFavorite)")){ (draftOrderResponsee:Drafts?) in
            if let draftOrder = draftOrderResponsee {
                let isInDraftOrder = draftOrderResponsee?.draftOrder?.lineItems?.contains { $0.title == productTitle }
                completion(isInDraftOrder ?? false)
            }else {
                completion(false)
            }
        }
        
  
    }
    
    }

