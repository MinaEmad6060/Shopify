//
//  PaymentOptionsViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 19/06/2024.
//

import UIKit

class PaymentOptionsViewController: UIViewController {
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cashTitleView: UIView!
    @IBOutlet weak var onlineTitleView: UIView!
    @IBOutlet weak var cashPaymentMV: UIView!
    @IBOutlet weak var onlinePaymentMV: UIView!

    var lineItems: [LineItemm] = []
    var subTotal = 0.0

    @IBAction func continuePaymentBtn(_ sender: Any) {
        if type == "cash"{
            navigateToPlaceOrder()
            
        }else{
            
            
        }
        
    }
    
    var type = "cash"
    @IBOutlet weak var onlinePaymentV: UIView!
    @IBAction func onlinePaymentBtn(_ sender: Any) {
        self.onlinePaymentV.backgroundColor = UIColor(hexString: "2C1E0F")
        self.cashPaymentV.backgroundColor = .white
        self.type = "Visa"
        UserDefaults.standard.set(type, forKey: "paymentMethod")
    }
    @IBOutlet weak var cashPaymentV: UIView!
    @IBAction func cashPaymentBtn(_ sender: Any) {
        self.onlinePaymentV.backgroundColor = .white
        self.cashPaymentV.backgroundColor = UIColor(hexString: "2C1E0F")
        self.type = "Cash"
        UserDefaults.standard.set(type, forKey: "paymentMethod")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onlinePaymentV.backgroundColor = .white
        self.cashPaymentV.backgroundColor = UIColor(hexString: "2C1E0F")
        self.onlinePaymentV.layer.cornerRadius = 12
        self.cashPaymentMV.layer.cornerRadius = 17
        self.onlinePaymentMV.layer.cornerRadius = 17
        self.cashPaymentV.layer.cornerRadius = 12
        self.onlineTitleView.roundCorners(corners: [.topRight, .bottomRight], radius: 20.0)
        self.cashTitleView.roundCorners(corners: [.topRight, .bottomRight], radius: 20.0)
        self.type = "cash"
                
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
            print(lineItems)
            placeOrderVC.subTotal = self.subTotal
            placeOrderVC.modalPresentationStyle = .fullScreen
            self.present(placeOrderVC, animated: true, completion: nil)
        }
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
