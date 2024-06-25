//
//  FavoriteViewModel.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import Foundation

class FavoriteViewModel {
    private var favoriteProductTitles: Set<String> = []
    var lineItems: [LineItem] = [] {
        didSet {
            self.didUpdateLineItems?()
        }
    }
    
    var fetchDataFromApi: FetchDataFromApi!
    
    init(){
        fetchDataFromApi = FetchDataFromApi()
    }
    
    
    var didUpdateLineItems: (() -> Void)?
    var displayedLineItems: [LineItem] {
         if lineItems.count > 1 {
             Constants.displayedLineItems = Array(lineItems.dropFirst())
             return Array(lineItems.dropFirst())
         } else {
             return []
         }
     }

    func fetchLineItems(draftOrderId: Int) {
        
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl,request: "draft_orders/\(draftOrderId)")){[weak self] (draftOrderResponsee:Drafts?) in
            if let draftOrder = draftOrderResponsee {
                self?.lineItems = draftOrder.draftOrder?.lineItems ?? [LineItem]()
            }else {
                print("No line items found")
            }
        }
        
        
        for item in self.lineItems {
                print("Title: \(item.title ?? ""), Price: \(item.price ?? ""), Image: \(item.image ?? "")")
            }
        didUpdateLineItems?()
    }
   
    func removeProductFromDraftOrder(productTitle: String) {
        let draftOrderIDFavorite = Utilites.getDraftOrderIDFavoriteFromNote()
        
        NetworkManager.removeLineItemFromDraftOrder(draftOrderId: draftOrderIDFavorite, productTitle: productTitle) { statusCode in
            if statusCode == 200 {
                print("Product removed from draft order successfully")
                
            } else {
                print("Failed to remove product from draft order. Status code: \(statusCode)")
            }
        }
        didUpdateLineItems?()
    }
}

