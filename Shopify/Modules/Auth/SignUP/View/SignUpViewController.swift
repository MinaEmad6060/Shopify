//
//  SignUpViewController.swift
//  Shopify
//
//  Created by maha on 11/06/2024.
//

import UIKit

class SignUpViewController: UIViewController {
    var signUpViewModel: SignUpViewModel?
    var checkConfirmPassword :String?
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var confirmPasswordTextField: UITextField!
  
    
    @IBOutlet weak var lnameTextField: UITextField!
    
    @IBOutlet weak var fnameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpViewModel = SignUpViewModel()
        
    }
    

    
    @IBAction func signUpBtn(_ sender: UIButton) {
        signUpViewModel?.customer.first_name = fnameTextField.text
        signUpViewModel?.customer.last_name = lnameTextField.text
        signUpViewModel?.customer.email = emailTextField.text
        signUpViewModel?.customer.tags = passwordTextField.text
              checkConfirmPassword = confirmPasswordTextField.text
              
        guard let customer = signUpViewModel?.customer else{
            print("customer is nullll*")
                  return
              }
        if fnameTextField.text != "" && lnameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" {
                   
            if signUpViewModel?.customer.tags == checkConfirmPassword {
                      signUpViewModel?.addCustomer(customer: customer)
                   }
                   else{
                       Utilites.displayToast(message: "Confirm Password and Password must be identical", seconds: 2.0, controller: self)
                       print("Confirm Password and Password must be identical")
                   }
               }else{
                   Utilites.displayToast(message: "Enter Full Data", seconds: 2.0, controller: self)
                   print("Enter Full Data")
               }
       
               
    }
    
}
