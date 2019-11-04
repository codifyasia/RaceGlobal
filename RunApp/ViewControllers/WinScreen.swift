//
//  WinScreen.swift
//  RunApp
//
//  Created by Ricky Wang on 10/1/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class WinScreen: UIViewController {
    
    @IBOutlet weak var WonLabel: UILabel!
    var phoneNum = ""
    var ref : DatabaseReference!
    var StringLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    @IBAction func goToMessages(_ sender: Any) {
        
    }
    func retrievePhoneNum() {
        
    }
    
    func retrieveData() {
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            self.phoneNum = value["Phone"] as! String
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        var newString = "1-"
        for i in 1...10 {
            if (i == 4 || i == 7) {
                newString = newString + " "
            }
            newString = newString + String(phoneNum[phoneNum.index(phoneNum.startIndex, offsetBy: i-1)])
        }
        phoneNum = newString
        print(phoneNum)
        WonLabel.text = phoneNum
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
