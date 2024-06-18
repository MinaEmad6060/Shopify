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

    func fetchLineItems(draftOrderId: Int) {
        NetworkManager.fetchLineItemsInDraftOrder(draftOrderId: draftOrderId) { [weak self] lineItems in
            guard let self = self else { return }
            if let lineItems = lineItems {
                self.lineItems = lineItems
            } else {
                print("No line items found")
            }
        }
    }
}

