//
//  Utilities.swift
//  Shopify
//
//  Created by maha on 12/06/2024.
//

import Foundation
import SystemConfiguration
import UIKit
class Utilites{
   static func displayToast(message : String, seconds: Double, controller: UIViewController){
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = UIColor.brown
            alert.view.layer.cornerRadius = 15
            controller.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
            }
        }
   static func getDraftOrderIDCart() -> Int {
        return UserDefaults.standard.integer(forKey: "draftOrderIDCart")
    }

    
    static  func getDraftOrderIDFavorite() -> Int {
        return UserDefaults.standard.integer(forKey: "draftOrderIDFavorite")
    }
    static  func getCustomerID() -> Int{
        return UserDefaults.standard.integer(forKey: "userID")
    }
    static  func getCustomerEmail() -> String{
        return UserDefaults.standard.string(forKey: "userEmail") ?? "Guest"
    }
    static  func getDraftOrderIDFavoriteFromNote() -> Int {
        return UserDefaults.standard.integer(forKey: "favIDNet")
    }
    static  func getDraftOrderIDCartFromNote() -> Int {
        return UserDefaults.standard.integer(forKey: "cartIDNet")
    }
    static  func getCustomerName() -> String {
        return UserDefaults.standard.string(forKey: "fname") ?? "none"
    }
}
