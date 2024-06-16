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
//        loginViewModel?.getAllCustomers()
//        loginViewModel?.bindingLogin = {[weak self] in
//            DispatchQueue.main.async{
//                if self?.loginViewModel?.checkCustomerAuth(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? "") == "Login Sucess"{
//                    print("sucess")
//                   
//                }else{
//                    print("failed")
//                }
//            }
//        }
//    }
        loginViewModel?.getAllCustomers()
                loginViewModel?.bindingLogin = {[weak self] in
                    DispatchQueue.main.async{
                        if self?.loginViewModel?.checkCustomerAuth(email: self?.emailTextField.text ?? "", password: self?.passwordTextField.text ?? "") == "Login Sucess" {
                            print("Login Success")
                            // Call the CreateDraft function after successful login
                           
                           /* let product = Product(id: 123,
                                                                 title: "Sample Product",
                                                                 body_html: "Sample HTML",
                                                                 product_type: "Sample Type",
                                                                 variants: [Variant(price: "20")],
                                                   options: [Options(name: "Color", values: ["Red", "Blue"])],
                                                                 image: ProductImage(id: 1, productID: 123, position: 1, width: 100, height: 100, src: "sample.jpg"))
                                           
                                           // Pass the product object to the createDraftWith function
                            self?.loginViewModel?.createDraftWith(product: product, note: "") { statusCode in
                                // Handle the completion if needed
                            }*/
                        } else {
                            print("Login Failed")
                        }
                    }
                }
            }
}
