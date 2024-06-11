//
//  LoginViewModel.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import Foundation
class LoginViewModel{
    var apiService = FetchDataFromApi()
    var bindingLogin:(()->()) = {}
    var observableLogin : LoginedCustomers?{
        didSet{
            bindingLogin()
        }
    }
    
    func getAllCustomers() {
            apiService.getSportData(url: apiService.formatUrl(request: "customers"), handler: { [weak self] (customers: LoginedCustomers) in
                self?.observableLogin = customers
            })
        }
}
