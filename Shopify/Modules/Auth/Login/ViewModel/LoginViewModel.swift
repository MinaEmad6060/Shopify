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
    func checkCustomerAuth(email:String , password: String)->String{
        var returnValue = "Uncorrect email or password"
        if let observale = observableLogin{
            print(observale.customers.count)
            for i in 0..<(observale.customers.count){
                if email == observale.customers[i].email && password == observale.customers[i].tags{
                    returnValue = "Login Sucess"
                }
                
            }
        }
       return returnValue
    }
}
