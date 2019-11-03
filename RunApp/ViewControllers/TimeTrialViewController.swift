//
//  TimeTrialViewController.swift
//  RunApp
//
//  Created by Michael Peng on 11/2/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class TimeTrialViewController: UIViewController {
    
    //Firebase reference
    var ref: DatabaseReference!
    
    //custom text
    var customNum : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        
    }
    @IBAction func startPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Distance", message: "Choose the distance you would like to have a time trial for", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "800 Meters", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 800])
            self.performSegue(withIdentifier: "toTrial", sender: self)
        }
        
        let action2 = UIAlertAction(title: "1600 Meters", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 1600])
            self.performSegue(withIdentifier: "toTrial", sender: self)
            
        }
        let action3 = UIAlertAction(title: "3200 Meters", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 3200])
            self.performSegue(withIdentifier: "toTrial", sender: self)
            
        }
        let action4 = UIAlertAction(title: "5 Kilometers", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 5000])
            self.performSegue(withIdentifier: "toTrial", sender: self)
        }
//        let action5 = UIAlertAction(title: "Custom Distance", style: .default) { (action) in
//            let customAlert = UIAlertController(title: "Distance", message: "Enter your Distance", preferredStyle: .alert)
//            customAlert.addTextField { (textField) in
//                textField.keyboardType = .numberPad
//                textField.placeholder = "Distance to run"
//                self.customNum = textField as! Int
//            }
//
//            let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
//
//                self.performSegue(withIdentifier: "toTrial", sender: self)
//            }
//
//            self.present(customAlert, animated: true, completion: nil)
//        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
//        alert.addAction(action5)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
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
