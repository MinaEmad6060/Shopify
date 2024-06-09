//
//  AddNewAddressViewModel.swift
//  Shopify
//
//  Created by Slsabel Hesham on 09/06/2024.
//

import Foundation

class AddNewAddressViewModel {
    var bindResultToNewAddressViewController: (() -> Void) = {}
    var success: Bool = false {
        didSet {
            bindResultToNewAddressViewController()
        }
    }

    func addNewAddress(customerId: Int, country: String, city: String, address: String, phone: String) {
        let newAddress = Address(country: country, city: city, address: address, phone: phone)
        
        NetworkManager.addNewAddress(customerID: customerId, address: newAddress) { [weak self] success in
            self?.success = success
        }
    }
}
