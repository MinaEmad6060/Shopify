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
      



    func getCurrentCustomer() {
        let email = Utilites.getCustomerEmail()
        NetworkManager.getCustomer(email: email) { customer in
            
            print("Customer ID****: \(customer?.id)")
            print("Customer note****: \(customer?.note)")
            let fname = customer?.first_name
            print("FirstName: \(fname)")
            UserDefaults.standard.set(fname, forKey: "fname")
            let userID = customer?.id
            print("userID: \(userID)")
            UserDefaults.standard.set(userID, forKey: "userID")
            if let note = customer?.note {
                
                let components = note.split(separator: ",")
                
                if components.count == 2,
                   let firstID = Int(components[0]),
                   let secondID = Int(components[1]) {
                    print("First ID: \(firstID)")
                    print("Second ID: \(secondID)")
                    UserDefaults.standard.set(firstID, forKey: "favIDNet")
                    UserDefaults.standard.set(secondID, forKey: "cartIDNet")
                    let result = UserDefaults.standard.integer(forKey: "favIDNet")
                    UserDefaults.standard.integer(forKey: "cartIDNet")
                    print("favID afteter Net: \(result)")
                } else {
                    print("Note does not contain two valid IDs")
                }
            } else {
                print("Customer note is nil or does not contain valid IDs")
            }
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

        let draftOrderIDFavorite = Utilites.getDraftOrderIDFavorite()

        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl,request: "draft_orders/\(draftOrderIDFavorite)")){ (draftOrderResponsee:Drafts?) in
            if let draftOrder = draftOrderResponsee {
                let isInDraftOrder = draftOrderResponsee?.draftOrder?.lineItems?.contains { $0.title == productTitle }
                completion(isInDraftOrder ?? false)
            }else {

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

