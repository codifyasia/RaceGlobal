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

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        self.layer.cornerRadius = 5000
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        return self.applyGradient(colours: colours, locations: nil)
        
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        gradient.cornerRadius = gradient.frame.height / 2
        return gradient
    }
}

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
        
        

        //making the the register Button look better
        alreadyHaveAccount.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.layer.cornerRadius = registerButton.frame.height / 2    }
    
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
                    self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).setValue(["FirstName" : self.FirstName.text, "LastName" : self.LastName.text, "Username" : self.Username.text, "Phone" : self.phoneNumberField.text, "CompletedRaces" : 0, "TotalDistance" : 0, "Wins" : 0, "Best800" : 0.0, "Best1600" : 0.0, "Best3200" : 0.0 , "Best5000" : 0.0, "Lobby" : 0, "DistanceGoal" : 1600, "MileSplitGoal" : 7, "RacesToWin" : 3])
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     
     
     SVProgressHUD.show()
                    if (FirstName.text?.isEmpty ?? true || LastName.text?.isEmpty ?? true || Email.text?.isEmpty ?? true || Password.text?.isEmpty ?? true) {
                        SVProgressHUD.dismiss()
                        print("THERE IS AN ERROR")
                        let alert = UIAlertController(title: "Registration Error", message: "Please make sure you have completed filled out every textfield", preferredStyle: .alert)
                        
                        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                            return
                        }
                        
                        alert.addAction(OK)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        Auth.auth().createUser(withEmail: Email.text!, password: Password.text!) { (user, error) in
                            if (error == nil) {
                                self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).setValue(["FirstName" : self.FirstName.text, "LastName" : self.LastName.text])
                                if (self.isStudent) {
                                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).updateChildValues(["Status" : "Student"])
                                }
                                else {
                                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).updateChildValues(["Status" : "Teacher"])
                                }
                                SVProgressHUD.dismiss()
                                print("Going to MAIN MENU")
            //                    self.performSegue(withIdentifier: "goToMainMenu", sender: self)
                            } else {
                                SVProgressHUD.dismiss()

                                let alert = UIAlertController(title: "Registration Error", message: "Please check to make sure you have met all the registration guidelines", preferredStyle: .alert)

                                let OK = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                    self.Password.text = ""
                                })

                                alert.addAction(OK)
                                self.present(alert, animated: true, completion: nil)
            //
                                print("Error: \(error)")
                            }
                        }
                    }
     }
     */
}
