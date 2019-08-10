//
//  SignUpViewController.swift
//  RunApp
//
//  Created by Michael Peng on 8/6/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: AkiraTextField!
    @IBOutlet weak var passwordField: AkiraTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func registerPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if (error == nil) {
                self.performSegue(withIdentifier: "goToMainMenu", sender: self)
                print("registrationerror")
            } else {
                print("registrationsuccess")
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
