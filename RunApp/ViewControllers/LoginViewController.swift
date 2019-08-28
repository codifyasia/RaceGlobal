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

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if (error == nil) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginToMain", sender: self)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
