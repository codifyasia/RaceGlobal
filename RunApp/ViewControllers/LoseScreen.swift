//
//  WinScreen.swift
//  RunApp
//
//  Created by Gavin on 10/21/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class LoseScreen: UIViewController {
    var ref: DatabaseReference!
    var phoneNum = ""
    @IBOutlet var runningFlash: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        retrieveData()
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    
    func startAnimation() {
        runningFlash.animation = Animation.named("runningFlash")
        runningFlash.loopMode = .loop
        runningFlash.play()
    }
    @IBAction func goToMessage(_ sender: Any) {
        let instagramHooks = "sms://1-408-334-5777"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL)
        {
            UIApplication.shared.openURL(instagramUrl! as URL)

         } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
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
