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
        
        
    }
    

    
    @IBAction func signUpBtn(_ sender: UIButton) {
        signUpViewModel?.customer?.first_name = fnameTextField.text
        signUpViewModel?.customer?.last_name = lnameTextField.text
        signUpViewModel?.customer?.email = lnameTextField.text
        signUpViewModel?.customer?.tags = passwordTextField.text
              checkConfirmPassword = confirmPasswordTextField.text
              
        guard let customer = signUpViewModel?.customer else{
                  return
              }
    }
    
}
