//
//  AddNewAddress.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import UIKit
import DropDown

class AddNewAddress: UIViewController {

    @IBAction func cityBtn(_ sender: Any) {
    }
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityView: UIView!
    @IBAction func countryBtn(_ sender: Any) {
        countryDropDown.show()
    }
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryView: UIView!
    var viewModel: AddNewAddressViewModel?
    let countryDropDown = DropDown()
    let countries = ["Egypt" , "UAE", "Italy"]
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
        
        countryDropDown.anchorView = countryView
        countryDropDown.dataSource = countries
        countryDropDown.bottomOffset = CGPoint(x: 0, y: (countryDropDown.anchorView?.plainView.bounds.height)!)
        countryDropDown.topOffset = CGPoint(x: 0, y: (countryDropDown.anchorView?.plainView.bounds.height)!)
        countryDropDown.direction = .bottom
        countryDropDown.selectionAction = { [weak self]
            (index: Int , item: String) in
            self?.countryLabel.text = self!.countries[index]
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
