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
   
    //init(product: Product?) {

  //  var product : BrandProductViewData?
    init(product: BrandProductViewData?) {
        self.product = product
        self.customerId = Utilites.getCustomerID()
       // getCurrentCustomer()
    
    }
   
    func updateCartDraftOrder(product: BrandProductViewData){
        guard let draftOrderIDCart = draftOrderIDCart else {
                    print("Cart draft order ID is not available")
                    return
                }
        NetworkManager.updateDraftOrder(draftOrderId: draftOrderIDCart, product: product) { statusCode in
            if statusCode == 200 {
                print("Draft order updated successfully")
            } else {
                print("Failed to update draft order. Status code: \(statusCode)")
            }
        }}
   func updateFavoriteDraftOrder(product: BrandProductViewData){
        guard let draftOrderIDFavorite = draftOrderIDFavorite else {
                    print("Cart draft order ID is not available")
                    return
                }
        NetworkManager.updateDraftOrder(draftOrderId: draftOrderIDFavorite , product: product) { statusCode in
            if statusCode == 200 {
                print("Draft order updated successfully")
            } else {
                print("Failed to update draft order. Status code: \(statusCode)")
            }
        }}
      
        func getCurrentCustomer() {
            NetworkManager.getCustomer(customerID: customerId) { customer in
               
                print("Customer ID****: \(customer?.id)")
                print("Customer note****: \(customer?.note)")
                
                if let note = customer?.note {
                    
                    let components = note.split(separator: ",")
                    
                    if components.count == 2,
                       let firstID = Int(components[0]),
                       let secondID = Int(components[1]) {
                        print("First ID: \(firstID)")
                        print("Second ID: \(secondID)")
                        self.draftOrderIDFavorite = firstID
                        self.draftOrderIDCart = secondID
                        UserDefaults.standard.set(self.draftOrderIDFavorite, forKey: "favIDNet")
                       let result = UserDefaults.standard.integer(forKey: "favIDNet")
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
//                draftOrderIDFavorite else {
//            print("Draft order ID is not available")
//            print("**draftOrderIDFavorite**\(draftOrderIDFavorite)")
//            completion(false)
//            return
//        }
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
