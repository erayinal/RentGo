//
//  SignInController.swift
//  RentGo
//
//  Created by Eray İnal on 25.03.2025.
//

import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureSignUp = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        signUpLabel.addGestureRecognizer(tapGestureSignUp)
        signUpLabel.isUserInteractionEnabled = true
        
        let tapGestureForgotPassword = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        forgotPasswordLabel.addGestureRecognizer(tapGestureForgotPassword)
        forgotPasswordLabel.isUserInteractionEnabled = true
        
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if(emailTextField.text != "" && passwordTextField.text != ""){
            performSegue(withIdentifier: "fromSignInToHomeVC", sender: nil)
            
        } else{
            makeAlert(title: "ERROR", message: "Fill every field!")
        }
    }
    
    
    @objc func forgotPasswordTapped() {
        //performSegue(withIdentifier: "", sender: nil)
    }
    @objc func signUpLabelTapped() {
        performSegue(withIdentifier: "toSignUpPage", sender: nil)
    }
    
    
    

}
