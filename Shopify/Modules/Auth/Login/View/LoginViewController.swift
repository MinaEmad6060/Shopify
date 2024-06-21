//
//  LoginViewController.swift
//  Shopify
//
//  Created by maha on 10/06/2024.
//

import UIKit
import FirebaseAuth
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
                loginViewModel?.bindingLogin = { [weak self] in
                    DispatchQueue.main.async {
                        if self?.loginViewModel?.checkCustomerAuth(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? "") == "Login Sucess" {
                            print("Login Success")
                            self?.checkEmailVerificationStatus()
                        } else {
                            Utilites.displayToast(message: "Login Failed", seconds: 2.0, controller: self ?? UIViewController())
                        }
                    }
                }
            }
  
    private func checkEmailVerificationStatus() {
           if let user = Auth.auth().currentUser {
               user.reload { [weak self] error in
                   guard error == nil else {
                       Utilites.displayToast(message: "Error reloading user: \(error?.localizedDescription ?? "Unknown error")", seconds: 2.0, controller: self ?? UIViewController())
                       return
                   }
                   if user.isEmailVerified {
                       self?.navigateToHomeScreen()
                   } else {
                       Utilites.displayToast(message: "Please verify your email before logging in.", seconds: 2.0, controller: self ?? UIViewController())
                   }
               }
           }
       }
       
    private func navigateToHomeScreen() {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController {
                
                tabBarController.selectedIndex = 0
                tabBarController.modalPresentationStyle = .fullScreen
                
                present(tabBarController, animated: true, completion: nil)
            }
     }
    
}
