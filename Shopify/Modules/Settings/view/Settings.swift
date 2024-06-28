//
//  Settings.swift
//  Shopify
//
//  Created by Slsabel Hesham on 13/06/2024.
//

import UIKit
import DropDown
import Alamofire

class Settings: UIViewController {
    @IBOutlet weak var curruncyLabel: UILabel!
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutBtn(_ sender: Any) {
        Utilites.logout()
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        if let login = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as? LoginViewController {
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true, completion: nil)
        }
    }
    @IBAction func curruncyBtn(_ sender: Any) {
        curruncyDropDown.show()
    }
    @IBOutlet weak var curruncyView: UIView!
    
    let curruncyDropDown = DropDown()
    let curruncies = ["EGP" , "EUR" , "USD"]
    var selectedCurrency: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchStoredCurrencyRate()
        
        
        curruncyDropDown.anchorView = curruncyView
        curruncyDropDown.dataSource = curruncies
        curruncyDropDown.bottomOffset = CGPoint(x: 0, y: (curruncyDropDown.anchorView?.plainView.bounds.height)!)
        curruncyDropDown.topOffset = CGPoint(x: 0, y: (curruncyDropDown.anchorView?.plainView.bounds.height)!)
        curruncyDropDown.direction = .bottom
        curruncyDropDown.selectionAction = { [weak self]
            (index: Int , item: String) in
            self?.fetchCurrencyRate(for: self!.curruncies[index])
            self?.curruncyLabel.text = self!.curruncies[index]
            
        }
    }
    func fetchCurrencyRate(for currency: String) {
            let apiKey = "1340b19647a0540114fc8da0" 
            let url = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(currency)"
            
        AF.request(url).responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        if let json = data as? [String: Any],
                           let rates = json["conversion_rates"] as? [String: Any],
                           let rate = rates["EGP"] as? Double {
                            self.selectedCurrency = Currency(code: currency, rate: rate)
                            self.storeSelectedCurrency()
                        }
                    case .failure(let error):
                        print("Error fetching currency rate: \(error)")
                    }
                }
            }
    

    func storeSelectedCurrency() {
            if let selectedCurrency = self.selectedCurrency {
                UserDefaults.standard.set(selectedCurrency.code, forKey: "selectedCurrencyCode")
                UserDefaults.standard.set(selectedCurrency.rate, forKey: "selectedCurrencyRate")
                print("Stored currency \(selectedCurrency.code) with rate \(selectedCurrency.rate)")
            }
        }
    
    func fetchStoredCurrencyRate() {
            if let storedCurrencyCode = UserDefaults.standard.string(forKey: "selectedCurrencyCode") {
                let storedCurrencyRate = UserDefaults.standard.double(forKey: "selectedCurrencyRate")
                self.curruncyLabel.text = storedCurrencyCode
                
            } else {
                self.curruncyLabel.text = "EGP"
            }
        }
}

struct Currency {
    let code: String
    let rate: Double
}
