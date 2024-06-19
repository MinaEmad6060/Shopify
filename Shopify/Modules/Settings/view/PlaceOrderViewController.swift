//
//  PlaceOrderViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 19/06/2024.
//

import UIKit

class PlaceOrderViewController: UIViewController {

    @IBOutlet weak var couponErrorLabel: UILabel!
    var lineItems: [LineItemm] = []
    var subTotal = 0.0
    var total = 0.0
    @IBOutlet weak var couponTF: UITextField!
 
    @IBAction func validateBtn(_ sender: Any) {
        guard let couponCode = couponTF.text, !couponCode.isEmpty else {
            print("Please enter a coupon code")
            return
        }
        
        validateDiscountCode(couponCode)
    }
    @IBOutlet weak var discountAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.subTotalLabel.text = "\(self.subTotal)"
        self.discountAmountLabel.text = "-0.0"
        self.totalLabel.text = "\(self.subTotal)"
    }
    
    @IBAction func placeOrderBtn(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func loadDiscountCodes() -> [DiscountCode] {
        guard let discountCodesDict = UserDefaults.standard.array(forKey: "AvailableDiscountCodes") as? [[String: String]] else {
            return []
        }
        
        return discountCodesDict.map { DiscountCode(code: $0["code"] ?? "", value: $0["value"] ?? "") }
    }
    func validateDiscountCode(_ code: String) {
        let availableCodes = loadDiscountCodes()
        print(availableCodes)
        if let discountCode = availableCodes.first(where: { $0.code == code }) {
            if !isDiscountCodeUsed(code) {
                useDiscountCode(code)
                print("Discount code applied successfully!")
                self.couponErrorLabel.text = "Applied successfully"
            } else {
                print("This discount code has already been used.")
                self.couponErrorLabel.text = "Already used"
            }
        } else {
            print("Invalid discount code.")
            self.couponErrorLabel.text = "Invalid discount code"
        }
    }
        
        func isDiscountCodeUsed(_ code: String) -> Bool {
            let usedCodes = UserDefaults.standard.array(forKey: "UsedDiscountCodes") as? [String] ?? []
            return usedCodes.contains(code)
        }
        
        func useDiscountCode(_ code: String) {
            var usedCodes = UserDefaults.standard.array(forKey: "UsedDiscountCodes") as? [String] ?? []
            usedCodes.append(code)
            UserDefaults.standard.setValue(usedCodes, forKey: "UsedDiscountCodes")
            UserDefaults.standard.removeObject(forKey: "SelectedDiscountCode")
        }
        
}
