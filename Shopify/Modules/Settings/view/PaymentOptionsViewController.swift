//
//  PaymentOptionsViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 19/06/2024.
//

import UIKit
import PassKit
class PaymentOptionsViewController: UIViewController {
    @IBOutlet weak var cashTitleView: UIView!
    @IBOutlet weak var onlineTitleView: UIView!
    @IBOutlet weak var cashPaymentMV: UIView!
    @IBOutlet weak var onlinePaymentMV: UIView!
    
    var lineItems: [LineItem] = []
    var subTotal = 0.0
    private var payment : PKPaymentRequest = PKPaymentRequest()
    @IBAction func continuePaymentBtn(_ sender: Any) {
        if type == "cash"{
            navigateToPlaceOrder()
            
        }else{
            
            let amount = String(self.subTotal)
            payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "iPhone XR 128 GB", amount: NSDecimalNumber(string: amount))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: payment)
            if controller != nil {
                controller!.delegate = self
                present(controller!, animated: true, completion: nil)
            }
        }
        
    }
    
    var type = "cash"
    @IBOutlet weak var onlinePaymentV: UIView!
    @IBAction func onlinePaymentBtn(_ sender: Any) {
        self.onlinePaymentV.backgroundColor = .brown
        self.cashPaymentV.backgroundColor = .white
        self.type = "online"
    }
    @IBOutlet weak var cashPaymentV: UIView!
    @IBAction func cashPaymentBtn(_ sender: Any) {
        self.onlinePaymentV.backgroundColor = .white
        self.cashPaymentV.backgroundColor = .brown
        self.type = "cash"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onlinePaymentV.backgroundColor = .white
        self.cashPaymentV.backgroundColor = .brown
        self.onlinePaymentV.layer.cornerRadius = 15
        self.cashPaymentMV.layer.cornerRadius = 15
        self.onlinePaymentMV.layer.cornerRadius = 17
        self.cashPaymentV.layer.cornerRadius = 17
        self.onlineTitleView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 15.0)
        self.cashTitleView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 15.0)
        self.type = "cash"
        // Do any additional setup after loading the view.
        
        payment.merchantIdentifier = "merchant.com.pushpendra.pay"
        payment.supportedNetworks = [.quicPay, .masterCard, .visa]
        payment.supportedCountries = ["IN", "US"]
        payment.merchantCapabilities = .capability3DS
        payment.countryCode = "IN"
        payment.currencyCode = "INR"
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func navigateToPlaceOrder() {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let placeOrderVC = storyboard.instantiateViewController(withIdentifier: "PlaceOrderVC") as? PlaceOrderViewController {
            placeOrderVC.lineItems = self.lineItems
            placeOrderVC.subTotal = self.subTotal
            placeOrderVC.modalPresentationStyle = .fullScreen
            self.present(placeOrderVC, animated: true, completion: nil)
        }
    }
}

extension PaymentOptionsViewController : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            controller.dismiss(animated: true) { [weak self] in
                self?.navigateToPlaceOrder()
            }
        }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
