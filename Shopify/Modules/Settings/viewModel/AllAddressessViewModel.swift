//
//  AllAddressessViewModel.swift
//  Shopify
//
//  Created by Slsabel Hesham on 12/06/2024.
//

import Foundation

class AllAddressesViewModel {
    var bindResultToAllAddressViewController: (() -> Void) = {}
    var success: Bool = false {
        didSet {
            bindResultToAllAddressViewController()
        }
    }
    
    var addresses: [Address] = []

    func getAllAddress(customerId: Int) {
        let url = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/customers/\(customerId)/addresses.json"
        
        NetworkManager.getDataFromApi(url: url) { (result: AddressResponse) in
            self.addresses = result.addresses
            self.success = true
        }
    }
}
