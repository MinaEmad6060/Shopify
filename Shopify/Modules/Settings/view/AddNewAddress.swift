//
//  AddNewAddress.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import UIKit
import DropDown

class AddNewAddress: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBAction func cityBtn(_ sender: Any) {
        cityDropDown.show()
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
    let cityDropDown = DropDown()
    let countries = ["Egypt" , "UAE"]
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
        addressView.layer.cornerRadius = 25.0
        addAdress.layer.cornerRadius = 50.0
        
        countryDropDown.anchorView = countryView
        countryDropDown.dataSource = countries
        countryDropDown.bottomOffset = CGPoint(x: 0, y: (countryDropDown.anchorView?.plainView.bounds.height)!)
        countryDropDown.topOffset = CGPoint(x: 0, y: (countryDropDown.anchorView?.plainView.bounds.height)!)
        countryDropDown.direction = .bottom
        countryDropDown.selectionAction = { [weak self]
            (index: Int , item: String) in
            self?.countryLabel.text = self!.countries[index]
            if self!.countries[index] == "Egypt"{
                self!.cityDropDown.dataSource = self!.egyptianCities
            } else{
                self!.cityDropDown.dataSource = self!.uaeCities
            }
            self?.cityLabel.text = "Select City"
        }
        
        cityDropDown.anchorView = cityView
        cityDropDown.bottomOffset = CGPoint(x: 0, y: (cityDropDown.anchorView?.plainView.bounds.height)!)
        cityDropDown.topOffset = CGPoint(x: 0, y: (cityDropDown.anchorView?.plainView.bounds.height)!)
        cityDropDown.direction = .bottom
        cityDropDown.selectionAction = { [weak self]
            (index: Int , item: String) in
            self?.cityLabel.text = self!.cityDropDown.dataSource[index]
        }
    }
    
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
   
    @IBOutlet weak var addAdress: UIButton!
    
    @IBAction func addAddressBtn(_ sender: Any) {
        viewModel?.addNewAddress(customerId: 7423232082091, country: countryLabel.text ?? "", city: cityLabel.text ?? "", address: addressTF.text ?? "", phone: phoneTF.text ?? "")
    }
    
    let egyptianCities = [
        "Cairo",
        "Alexandria",
        "Giza",
        "Shubra El Kheima",
        "Port Said",
        "Suez",
        "El Mahalla El Kubra",
        "Luxor",
        "Mansoura",
        "Tanta",
        "Asyut",
        "Ismailia",
        "Faiyum",
        "Zagazig",
        "Damietta",
        "Aswan",
        "Minya",
        "Damanhur",
        "Beni Suef",
        "Qena",
        "Sohag",
        "Hurghada",
        "6th of October City",
        "Shibin El Kom",
        "Banha",
        "Kafr El Sheikh",
        "Arish",
        "Mallawi",
        "10th of Ramadan City",
        "Bilbeis",
        "Marsa Matruh",
        "Idfu",
        "Mit Ghamr",
        "Al Hawamdeyah",
        "Desouk",
        "Qalyub",
        "Abu Kabir",
        "Girga",
        "Akhmim",
        "Matareya",
        "Manfalut",
        "Qena",
        "El Quweisna",
        "New Cairo",
        "Obour City",
        "Sadat City",
        "Badr City",
        "New Alamein City",
        "New Tiba"
    ]
    let uaeCities = [
        "Abu Dhabi",
        "Dubai",
        "Sharjah",
        "Al Ain",
        "Ajman",
        "Ras Al Khaimah",
        "Fujairah",
        "Umm Al Quwain",
        "Khor Fakkan",
        "Kalba",
        "Dibba Al-Fujairah",
        "Dibba Al-Hisn",
        "Jebel Ali",
        "Al Dhafra",
        "Hatta",
        "Ruways",
        "Madīnat Zāyid",
        "Liwa Oasis",
        "Ghiyathi",
        "Muzayri‘",
        "Ar-Rams",
        "Al Jazirah Al Hamra",
        "Masafi",
        "Al Madam",
        "Al Halah",
        "Al Faqa",
        "Al Dhaid",
        "Al Qusaidat",
        "Al Hamraniyah",
        "Al Rafaah"
    ]
}
