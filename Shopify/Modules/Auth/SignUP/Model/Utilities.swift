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
    static func getDraftOrderIDFavorite() -> Int {
        return UserDefaults.standard.integer(forKey: "draftOrderIDFavorite")
    }
    static func getCustomerID() -> Int{
        return UserDefaults.standard.integer(forKey: "userID")
    }
    static func getCustomerEmail() -> String{
        return UserDefaults.standard.string(forKey: "userEmail") ?? "Guest"
    }
    static func getDraftOrderIDFavoriteFromNote() -> Int {
        return UserDefaults.standard.integer(forKey: "favIDNet")
    }
    static func getDraftOrderIDCartFromNote() -> Int {
        return UserDefaults.standard.integer(forKey: "cartIDNet")
    }

    static  func getCustomerName() -> String {
        return UserDefaults.standard.string(forKey: "fname") ?? "none"

    }
    
    static func getCurrencyCode() -> String {
        return UserDefaults.standard.string(forKey: "selectedCurrencyCode") ?? "EGP"
    }
    static func getCurrencyRate() -> String {
        return UserDefaults.standard.string(forKey: "selectedCurrencyRate") ?? "1"
    }
    static func getPaymentMethod() -> String {
        return UserDefaults.standard.string(forKey: "paymentMethod") ?? "Cash"
    }
    static func displayGuestAlert(in viewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "Guest Mode", message: message, preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "Log In", style: .default) { _ in
            // Navigate to the login screen
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                loginVC.modalPresentationStyle = .fullScreen
                viewController.present(loginVC, animated: true, completion: nil)
            }
        }
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .default) { _ in
            // Navigate to the sign-up screen
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUPVC") as? SignUpViewController {
                signUpVC.modalPresentationStyle = .fullScreen
                viewController.present(signUpVC, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(loginAction)
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }

}
