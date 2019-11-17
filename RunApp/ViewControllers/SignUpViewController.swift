//
//  SignUpViewController.swift
//  RunApp
//
//  Created by Michael Peng on 8/6/19.
//  Copyright © 2019 Michael Peng. All rights reserved. yeet
//

import UIKit
import Firebase
import TextFieldEffects
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var FirstName: AkiraTextField!
    @IBOutlet weak var LastName: AkiraTextField!
    @IBOutlet weak var Username: AkiraTextField!
    @IBOutlet weak var emailField: AkiraTextField!
    @IBOutlet weak var passwordField: AkiraTextField!
    @IBOutlet weak var alreadyHaveAccount: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var phoneNumberField: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.scroll.delegate = self
        
        scroll.keyboardDismissMode = .onDrag
        //making the alreadyHaveAccount button look better
//        alreadyHaveAccount.backgroundColor = UIColor.lightGray
//        alreadyHaveAccount.layer.cornerRadius = alreadyHaveAccount.frame.height / 2
////        alreadyHaveAccount.setTitleColor(UIColor.white, for: .normal)
//
//        alreadyHaveAccount.layer.shadowColor = UIColor.white.cgColor
//        alreadyHaveAccount.layer.shadowRadius = 4
//        alreadyHaveAccount.layer.shadowOpacity = 1
//        alreadyHaveAccount.layer.shadowOffset = CGSize(width: 0, height: 0)
//
//        //making the the register Button look better
//        registerButton.backgroundColor = UIColor.lightGray
//        registerButton.layer.cornerRadius = registerButton.frame.height / 2 - 5
//
//        registerButton.layer.shadowColor = UIColor.white.cgColor
//        registerButton.layer.shadowRadius = 4
//        registerButton.layer.shadowOpacity = 1
//        registerButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    //TODO:Touch out
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        SVProgressHUD.show()
        if (FirstName.text?.isEmpty ?? true || LastName.text?.isEmpty ?? true || Username.text?.isEmpty ?? true || emailField.text?.isEmpty ?? true || passwordField.text?.isEmpty ?? true || passwordField.text?.isEmpty ?? true || phoneNumberField.text?.isEmpty ?? true) {
            SVProgressHUD.dismiss()
            print("THERE IS AN ERROR")
            let alert = UIAlertController(title: "Registration Error", message: "Please make sure you have completed filled out every textfield", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                return
            }
            
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if (error == nil) {
                    self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).setValue(["FirstName" : self.FirstName.text, "LastName" : self.LastName.text, "Username" : self.Username.text, "Phone" : self.phoneNumberField.text, "CompletedRaces" : 0, "TotalDistance" : 0, "Wins" : 0, "BestMile" : 0.0, "Best5k" : 0.0, "Best800" : 0.0, "Lobby" : 0])
                    SVProgressHUD.dismiss()
                    print("Going to MAIN MENU")
                    self.performSegue(withIdentifier: "goToMainMenu", sender: self)
                } else {
                    SVProgressHUD.dismiss()
                    
                    let alert = UIAlertController(title: "Registration Error", message: "Please check to make sure you have met all the registration guidelines", preferredStyle: .alert)
                    
                    let OK = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.passwordField.text = ""
                    })
                    
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                    
                    print("Error: \(error)")
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
