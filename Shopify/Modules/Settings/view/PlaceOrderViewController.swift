//
//  PlaceOrderViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 19/06/2024.
//

import UIKit
import PassKit

class PlaceOrderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var orderCouponsCollectionView: UICollectionView!
    @IBOutlet weak var orderCollectionView: UICollectionView!
    
    private var payment : PKPaymentRequest = PKPaymentRequest()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == orderCollectionView {
            return lineItems.count
        } else {
            return discountCodes.count
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == orderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderSummaryCollectionViewCell
            
            let lineItem = lineItems[indexPath.row]
            cell.orderName.text = lineItem.title
            cell.orderAmount.text = "\(lineItem.quantity)"
            
            if let properties = lineItem.properties, properties.count > 2, let url = URL(string: properties[2].value) {
                cell.orderImage.kf.setImage(with: url)
                cell.orderSize.text = "size: \(properties[0].value)"
                cell.orderColor.text = "color: \(properties[1].value)"
            }
            
            let quantity = lineItem.quantity
            let price = lineItem.price
            
            if let priceDouble = Double(price) {
                let totalPrice = Double(quantity) * priceDouble
                cell.orderPrice.text = "\(Double(totalPrice) / (Double(Utilites.getCurrencyRate()) ?? 1)) \(Utilites.getCurrencyCode())"
            } else {
                cell.orderPrice.text = "E"
            }
            cell.orderAmountView.layer.borderWidth = 1.5
            cell.orderAmountView.layer.borderColor = UIColor(hexString: "AE9376").cgColor
            cell.orderAmountView.layer.cornerRadius = 15.0
            
            cell.orderView.layer.borderWidth = 1.5
            cell.orderView.layer.borderColor = UIColor(hexString: "AE9376").cgColor
            cell.orderView.layer.cornerRadius = 15.0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCouponsCell", for: indexPath) as! OrderCouponsCollectionViewCell
            
            let discountCode = discountCodes[indexPath.row]
            cell.orderCoupon.text = discountCode
            
            cell.orderCouponView.layer.borderWidth = 1.5
            cell.orderCouponView.layer.borderColor = UIColor(hexString: "AE9376").cgColor
            cell.orderCouponView.layer.cornerRadius = 15.0
            return cell
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == orderCollectionView {
            return CGSize(width: 250.0, height: 150.0)
        } else {
            return CGSize(width: 220.0, height: 40.0)
        }
    }
    
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
    var discountCodes: [String] = []

    var subTotal = 0.0
    var total = 0.0
    let customer: [String: Any] = [
        "id": Utilites.getCustomerID(),
        "currency": Utilites.getCurrencyCode()
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
        if self.addressLabel.text == "Address"{
            self.changeAddress.titleLabel?.text = "Set"
            
        }else{
            self.changeAddress.titleLabel?.text = "Change"
        }
        self.paymentLabel.text = "Payment: \(Utilites.getPaymentMethod())"
        allAddressesViewModel?.getAllAddress(customerId: Utilites.getCustomerID())
        
        discountCodes = loadDiscountCodes()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderCollectionView.delegate = self
        orderCollectionView.dataSource = self
        
        orderCouponsCollectionView.delegate = self
        orderCouponsCollectionView.dataSource = self
        
        print("/*///*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/")
        print(discountCodes)
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
        let formattedPrice = String(format: "%.1f", Double(self.subTotal))

        self.subTotalLabel.text =  "\((Double(formattedPrice) ?? 0) / (Double(Utilites.getCurrencyRate()) ?? 1)) \(Utilites.getCurrencyCode())"
        self.discountAmountLabel.text = "-0.0 \(Utilites.getCurrencyCode())"
        self.totalLabel.text = "\(Double(self.subTotal) / (Double(Utilites.getCurrencyRate()) ?? 1)) \(Utilites.getCurrencyCode())"

        
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
            Utilites.displayToast(message: "Added to cart!", seconds: 2.0, controller: self)
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
    
    func loadDiscountCodes() -> [String] {
        if let discountCodesArray = UserDefaults.standard.array(forKey: "AvailableDiscountCodes") as? [String] {
            return discountCodesArray
        } else {
            return []
        }
    }

    func validateDiscountCode(_ code: String) {
        let availableCodes = loadDiscountCodes()
        print(availableCodes)
        
        if availableCodes.contains(where: { $0 == code }) {
            if !isDiscountCodeUsed(code) {
                useDiscountCode(code)
                print("Discount code applied successfully!")
                
                // Assuming all discount codes have a fixed value of 10% discount for simplicity
                let discountValue = 10.0 // Example discount value
                let absoluteDiscountValue = abs(discountValue)
                let discountAmount = calculateDiscount(totalPrice: subTotal, discountValue: absoluteDiscountValue)
                let newTotalPrice = subTotal - discountAmount
                print("Discount Value: \(absoluteDiscountValue)")
                print("Discount Amount: \(discountAmount)")
                print("New Total Price: \(newTotalPrice)")
                
                self.discountAmountLabel.text = "\(discountAmount / (Double(Utilites.getCurrencyRate()) ?? 1)) \(Utilites.getCurrencyCode())"
                self.totalLabel.text = "\(newTotalPrice / (Double(Utilites.getCurrencyRate()) ?? 1)) \(Utilites.getCurrencyCode())"
            } else {
                print("This discount code has already been used.")
                self.couponErrorLabel.text = "Already used"
            }
        } else {
            print("Invalid discount code.")
            self.couponErrorLabel.text = "Invalid discount code"
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
