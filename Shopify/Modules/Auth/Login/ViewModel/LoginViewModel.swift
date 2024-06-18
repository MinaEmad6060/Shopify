//
//  LoginViewModel.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import Foundation
class LoginViewModel{
    var product: Product?
    var apiService = FetchDataFromApi()
    var bindingLogin:(()->()) = {}
    var observableLogin : LoginedCustomers?{
        didSet{
            bindingLogin()
        }
    }
    
    func getAllCustomers() {
        apiService.getDataFromApi(url: apiService.formatUrl(baseUrl: Constants.baseUrl, request: "customers"), handler: { [weak self] (customers: LoginedCustomers) in
            self?.observableLogin = customers
        })
    }
    /*
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
*/
    func checkCustomerAuth(email: String, password: String) -> String {
            var returnValue = "Incorrect email or password"
            
            if let observable = observableLogin {
                for customer in observable.customers {
                    if email == customer.email && password == customer.tags {
                        // Save user ID and email to UserDefaults
                        UserDefaults.standard.set(customer.id, forKey: "userID")
                        UserDefaults.standard.set(customer.email, forKey: "userEmail")
                        returnValue = "Login Sucess"
                        
                        // Print stored user info
                        printStoredUserInfo()
                        break
                    }
                }
            }
            
            return returnValue
        }
        
       func printStoredUserInfo() {
           if let userID = UserDefaults.standard.string(forKey: "userID"),
              let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
               print("User ID from login: \(userID)")
               print("User Email from login: \(userEmail)")
           } else {
               print("No user information found in UserDefaults.")
           }
       }
   
}
