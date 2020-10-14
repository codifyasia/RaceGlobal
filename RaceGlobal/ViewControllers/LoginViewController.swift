//
//  LoginViewController.swift
//  RunApp
//
//  Created by Michael Peng on 8/6/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import SVProgressHUD
import Lottie

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 20
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if (error == nil) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMainMenu", sender: self)
            } else {
                
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Login Error", message: "Incorrect username or password", preferredStyle: .alert)
                let forgotPassword = UIAlertAction(title: "Forgot Password?", style: .default, handler: { (UIAlertAction) in
                    //do the forgot password shit
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
                    //do nothing
                })
                
                alert.addAction(forgotPassword)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                print("error with logging in: ", error!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func backToRegister(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
