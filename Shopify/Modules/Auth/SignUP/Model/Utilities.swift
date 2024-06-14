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
        
}
