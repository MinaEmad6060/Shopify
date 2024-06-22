//
//  FavoriteViewModel.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import Foundation

class FavoriteViewModel {
    var lineItems: [LineItem] = [] {
        didSet {
            self.didUpdateLineItems?()
        }
    }
    
    var didUpdateLineItems: (() -> Void)?
    var displayedLineItems: [LineItem] {
         if lineItems.count > 1 {
             return Array(lineItems.dropFirst())
         } else {
             return []
         }
     }

    func fetchLineItems(draftOrderId: Int) {
        NetworkManager.fetchLineItemsInDraftOrder(draftOrderId: draftOrderId) { [weak self] lineItems in
            guard let self = self else { return }
            if let lineItems = lineItems {
                self.lineItems = lineItems
            } else {
                print("No line items found")
            }
        }
        for item in self.lineItems {
                print("Title: \(item.title ?? ""), Price: \(item.price ?? ""), Image: \(item.image ?? "")")
            }
    }
    
}

