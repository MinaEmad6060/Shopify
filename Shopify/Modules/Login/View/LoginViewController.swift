//
//  LoginViewController.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import UIKit

class LoginViewController: UIViewController {
    var loginViewModel: LoginViewModel?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel = LoginViewModel()
    }
    

    
    
    @IBAction func goToSignUp(_ sender: UIButton) {
        //SignUPVC
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUPVC") as! SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(signUpViewController, animated: true)
    }
    @IBAction func signInBtn(_ sender: UIButton) {
        loginViewModel?.getAllCustomers()
        loginViewModel?.bindingLogin = {[weak self] in
            DispatchQueue.main.async{
                if self?.loginViewModel?.checkCustomerAuth(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? "") == "Login Sucess"{
                    print("sucess")
                }else{
                    print("failed")
                }
            }
        }
    }
    
}
