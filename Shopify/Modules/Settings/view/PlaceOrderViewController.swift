//
//  PlaceOrderViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 19/06/2024.
//

import UIKit
import PassKit

class PlaceOrderViewController: UIViewController {
    
    
    private var payment : PKPaymentRequest = PKPaymentRequest()
    
    @IBAction func changePayment(_ sender: Any) {
        let payment = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PaymentOptionsVC") as! PaymentOptionsViewController
        present(payment, animated: true)
    }
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var changeAddress: UIButton!
    var allAddressesViewModel: AllAddressesViewModel?
    
    @IBAction func changeAddress(_ sender: Any) {
        if self.changeAddress.titleLabel?.text == "Change"{
            let addressess = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "addresses") as! AllAddressess
            present(addressess, animated: true)
        } else{
            let addAddress = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "addAddress") as! AddNewAddress
            present(addAddress, animated: true)
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var couponErrorLabel: UILabel!
    var lineItems: [LineItemm] = []

    var subTotal = 0.0
    var total = 0.0
    let customer: [String: Any] = [
        "id": Utilites.getCustomerID(),
        "currency": "EGP"
    ]
    @IBOutlet weak var couponTF: UITextField!
    
    @IBAction func validateBtn(_ sender: Any) {
        guard let couponCode = couponTF.text, !couponCode.isEmpty else {
            print("Please enter a coupon code")
            return
        }
        
        validateDiscountCode(couponCode)
    }
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var discountAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        self.paymentLabel.text = "Payment: \(Utilites.getPaymentMethod())"
        allAddressesViewModel?.getAllAddress(customerId: Utilites.getCustomerID())    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allAddressesViewModel = AllAddressesViewModel()
        allAddressesViewModel?.bindResultToAllAddressViewController = { [weak self] in
            DispatchQueue.main.async {
                if self?.allAddressesViewModel?.addresses.count == 0{
                    self?.changeAddress.titleLabel?.text = "Set"
                }else{
                    var addresses: [AddressId] = []
                    addresses = (self?.allAddressesViewModel!.addresses)!
                    for address in addresses{
                        if address.default == true {
                            print("testttttttt")
                            self?.addressLabel.text = address.address1
                        }
                    }
                }
            }
        }
        
        
        
        
        print(self.lineItems)
        // Do any additional setup after loading the view.
        self.subTotalLabel.text = "\(self.subTotal)EGP"
        self.discountAmountLabel.text = "-0.EGP"
        self.totalLabel.text = "\(self.subTotal)EGP"

        
        payment.merchantIdentifier = "merchant.com.pushpendra.pay"
        payment.supportedNetworks = [.quicPay, .masterCard, .visa]
        payment.supportedCountries = ["EG", "US"]
        payment.merchantCapabilities = .capability3DS
        payment.countryCode = "EG"
        payment.currencyCode = Utilites.getCurrencyCode()

    }
    
    @IBAction func placeOrderBtn(_ sender: Any) {
        print("placeOrderBtnCount :: \(lineItems.count)")
        if self.addressLabel.text != "No Address Set" && Utilites.getPaymentMethod() == "Cash"{
            print("1")
            FetchDataFromApi.postOrder(lineItems: lineItems, customer: customer)
        } else if self.addressLabel.text == "No Address Set" {
            print("2")

            Utilites.displayToast(message: "Please set your address first", seconds: 2.0, controller: self)
        } else {
            print("3")

            let amount = String(self.subTotal)
            payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "iPhone XR 128 GB", amount: NSDecimalNumber(string: amount))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: payment)
            if let paymentController = controller {
                //paymentController.delegate = paymentController
                present(paymentController, animated: true, completion: nil)
            }
            
        }
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
                
                if let discountValue = Double(discountCode.value) {
                    let absoluteDiscountValue = abs(discountValue)
                    let discountAmount = calculateDiscount(totalPrice: subTotal, discountValue: absoluteDiscountValue)
                    let newTotalPrice = subTotal - discountAmount
                    print("Discount Value: \(absoluteDiscountValue)")
                    print("Discount Amount: \(discountAmount)")
                    print("New Total Price: \(newTotalPrice)")
                    
                    self.discountAmountLabel.text = "-\(discountAmount)EGP"
                    self.totalLabel.text = "\(newTotalPrice)EGP"
                } else {
                    print("Invalid discount value format")
                }
            } else {
                print("This discount code has already been used.")
                // self.couponErrorLabel.text = "Already used"
            }
        } else {
            print("Invalid discount code.")
            // self.couponErrorLabel.text = "Invalid discount code"
        }
    }

    func calculateDiscount(totalPrice: Double, discountValue: Double) -> Double {
        return totalPrice * (discountValue / 100.0)
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
extension PaymentOptionsViewController : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            controller.dismiss(animated: true) { [weak self] in
                // animation and navigate to home
            }
        }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
