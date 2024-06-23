//
//  SplashViewController.swift
//  Shopify
//
//  Created by maha on 22/06/2024.
//

import UIKit

class SplashViewController: UIViewController {
    var customerID: Int?
    var customerEmail : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        customerID = Utilites.getCustomerID()
        customerEmail = Utilites.getCustomerEmail()
        //HomeVC
        if let id = customerID, id == 0 , let email = customerEmail, email.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.performSegue(withIdentifier: "WVC", sender: nil)
                    }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "HomeVC", sender: nil)
            }
        }
    }
    

   

}
