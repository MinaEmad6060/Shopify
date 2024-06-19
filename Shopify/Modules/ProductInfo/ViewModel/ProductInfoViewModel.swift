//
//  ProductInfoViewModel.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import Foundation
class ProdutInfoViewModel {
    var product : Product?
    var customerId: Int
   var  draftOrderIDFavorite: Int?
   
        var draftOrderIDCart: Int?
   
    init(product: Product?) {
        self.product = product
        self.customerId = Utilites.getCustomerID()
        getCurrentCustomer()
    }
   
    func updateCartDraftOrder(product: Product){
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
    func updateFavoriteDraftOrder(product: Product){
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
        /*
         func getCurrentCustomer(){
         NetworkManager.getCustomer(customerID: customerId) { customer in
         // Handle the fetched customer here
         print("Customer ID****: \(customer?.id)")
         print("Customer note****: \(customer?.note)")
         
         // Update the UI or perform other actions with the fetched customer data
         }
         }*/
        func getCurrentCustomer() {
            NetworkManager.getCustomer(customerID: customerId) { customer in
                // Handle the fetched customer here
                print("Customer ID****: \(customer?.id)")
                print("Customer note****: \(customer?.note)")
                
                if let note = customer?.note {
                    // Split the note string into components separated by comma
                    let components = note.split(separator: ",")
                    
                    // Convert the components into integers
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
        
    }

