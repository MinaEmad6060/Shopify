//
//  LoginViewModel.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import Foundation
class LoginViewModel{
    var bindingLogin:(()->()) = {}
    var observaleLogin : LoginedCustomers?{
        didSet{
            bindingLogin()
        }
    }

}
