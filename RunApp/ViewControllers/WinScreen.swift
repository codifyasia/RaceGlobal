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
    var currentLobby : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    @IBAction func goToMessages(_ sender: Any) {
        retrieveData()
    }
    
        func retrieveData() {
            ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { snapshot in
                print(snapshot.childrenCount)
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = rest.value as? NSDictionary else {
                        print("could not collect label data")
                        return
                    }
                    let uid = value["id"] as! String
                    if (uid != Auth.auth().currentUser!.uid) {
                        print("uid: " + uid)
                        self.ref.child("PlayerStats").child(uid).observeSingleEvent(of: .value) { snapshot in
                            guard let value = snapshot.value as? NSDictionary else {
                                print("No Data!!!!!!")
                                return
                            }
                            
                             let phoneNum = value["Phone"] as! String
                            print("phonenum: " + phoneNum)
                             let instagramHooks = "sms://12223334444" + phoneNum
                            //let instagramHooks = "sms://1" + phoneNum
                             let instagramUrl = NSURL(string: instagramHooks)
                             if UIApplication.shared.canOpenURL(instagramUrl! as URL)
                             {
                                 UIApplication.shared.openURL(instagramUrl! as URL)

                              } else {
                                 //redirect to safari because the user doesn't have Instagram
                                 UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
                             }
                            
                            //            self.goalDistance = value["SelectedDist"] as! Double
                        }
                    }
                
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
