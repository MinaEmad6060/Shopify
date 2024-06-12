//
//  SignUpViewModel.swift
//  Shopify
//
//  Created by maha on 11/06/2024.
//

import Foundation
class SignUpViewModel{
    var customer = Customer()
//    init(customer: Customer?) {
    //        self.customer = customer
    //    }
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
}
