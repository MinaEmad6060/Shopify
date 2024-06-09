//
//  AddNewAddress.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import UIKit
import TextFieldEffects

class AddNewAddress: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var countryTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
   
    @IBOutlet weak var addAdress: UIButton!
    
    @IBAction func addAddressBtn(_ sender: Any) {
        
    }

}
