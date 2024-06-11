//
//  AddNewAddress.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import UIKit
import TextFieldEffects

class AddNewAddress: UIViewController {

    var viewModel: AddNewAddressViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewModel = AddNewAddressViewModel()
        viewModel?.bindResultToNewAddressViewController = {
            if ((self.viewModel?.success) != nil) {
                print("Address added successfully")
            } else {
                print("Failed to add address")
            }
        }
    }
    
    @IBOutlet weak var countryTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
   
    @IBOutlet weak var addAdress: UIButton!
    
    @IBAction func addAddressBtn(_ sender: Any) {
        viewModel?.addNewAddress(customerId: 7423232082091, country: countryTF.text ?? "", city: cityTF.text ?? "", address: addressTF.text ?? "", phone: phoneTF.text ?? "")
    }

}
