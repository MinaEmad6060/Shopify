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
      
//         func getCurrentCustomer() {
//            NetworkManager.getCustomer(customerID: customerId) { customer in
//               
//                print("Customer ID****: \(customer?.id)")
//                print("Customer note****: \(customer?.note)")
//                let fname = customer?.first_name
//                print("FirstName: \(fname)")
//                UserDefaults.standard.set(fname, forKey: "fname")
//                if let note = customer?.note {
//                    
//                    let components = note.split(separator: ",")
//                    
//                    if components.count == 2,
//                       let firstID = Int(components[0]),
//                       let secondID = Int(components[1]) {
//                        print("First ID: \(firstID)")
//                        print("Second ID: \(secondID)")
//                        self.draftOrderIDFavorite = firstID
//                        self.draftOrderIDCart = secondID
//                        UserDefaults.standard.set(self.draftOrderIDFavorite, forKey: "favIDNet")
//                        UserDefaults.standard.set(self.draftOrderIDCart, forKey: "cartIDNet")
//                       let result = UserDefaults.standard.integer(forKey: "favIDNet")
//                        UserDefaults.standard.integer(forKey: "cartIDNet")
//                        print("favID afteter Net: \(result)")
//                    } else {
//                        print("Note does not contain two valid IDs")
//                    }
//                } else {
//                    print("Customer note is nil or does not contain valid IDs")
//                }
//                
//               
//            }
//        }
//    func getCurrentCustomer() {
//        let email = Utilites.getCustomerEmail()
//        NetworkManager.getCustomer(email: email) { customer in
//            
//            print("Customer ID****: \(customer?.id)")
//            print("Customer note****: \(customer?.note)")
//            let fname = customer?.first_name
//            print("FirstName: \(fname)")
//            UserDefaults.standard.set(fname, forKey: "fname")
//            let userID = customer?.id
//            print("userID: \(userID)")
//            UserDefaults.standard.set(userID, forKey: "userID")
//            if let note = customer?.note {
//                
//                let components = note.split(separator: ",")
//                
//                if components.count == 2,
//                   let firstID = Int(components[0]),
//                   let secondID = Int(components[1]) {
//                    print("First ID: \(firstID)")
//                    print("Second ID: \(secondID)")
//                    UserDefaults.standard.set(firstID, forKey: "favIDNet")
//                    UserDefaults.standard.set(secondID, forKey: "cartIDNet")
//                    let result = UserDefaults.standard.integer(forKey: "favIDNet")
//                    UserDefaults.standard.integer(forKey: "cartIDNet")
//                    print("favID afteter Net: \(result)")
//                } else {
//                    print("Note does not contain two valid IDs")
//                }
//            } else {
//                print("Customer note is nil or does not contain valid IDs")
//            }
//        }
//    }
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

