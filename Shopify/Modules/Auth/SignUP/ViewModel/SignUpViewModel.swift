//
//  SignUpViewModel.swift
//  Shopify
//
//  Created by maha on 11/06/2024.
//

import Foundation
class SignUpViewModel{
    var customer = Customer()
    var bindingSignUp:(()->()) = {}
        var ObservableSignUp : Int? {
            didSet {
                bindingSignUp()
            }
        }
        
    func addCustomer(customer:Customer){
        SignUpNetworkService.customerRegister(newCustomer: customer) { checkSignAblitiy in
            self.ObservableSignUp = checkSignAblitiy
        }

        
        }
    func createDraftWith(product: Product, note: String, completion: @escaping (Int) -> Void) {
            FetchDataFromApi.CreateDraft(product: product, note: note, complication: completion)
        }
}
