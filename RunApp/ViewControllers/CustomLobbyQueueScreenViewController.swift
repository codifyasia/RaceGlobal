//
//  CustomLobbyQueueScreenViewController.swift
//  RunApp
//
//  Created by Gavin Wong on 10/5/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class CustomLobbyQueueViewController : UIViewController {
    var lobbyCode = ""
    var ref : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        ref.child("CustomLobbies").child(lobbyCode).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!")
                return
            }
            let numPlayers = value["numPlayers"] as! Int
            //decrease number of Players by 1
            self.ref.child("CustomLobbies").child(self.lobbyCode).updateChildValues(["numPlayers" : numPlayers - 1])
            
            self.ref.child("CustomLobbies").child(self.lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot1) in
                guard let value1 = snapshot1.value as? NSDictionary else {
                        print("NO DATA!!!!")
                        return
                }
                
                self.ref.child("CustomLobbies").child(self.lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).removeValue()
                let index = value1["PlayerIndex"] as! Int
                if index == 1 {
                    self.ref.child("CustomLobbies").child(self.lobbyCode).removeValue()
                }
                self.fixLine(pos : index)
            }
        }
    }
    
    func fixLine(pos : Int) {
        if pos > 1 {
        ref.child("CustomLobbies").child(lobbyCode).child("Players").observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                        print("No DATA!!!")
                        return
                }
                let uid = value["id"] as! String
                let index = value["PlayerIndex"] as! Int
                if index > pos {
                    self.ref.child("CustomLobbies").child(self.lobbyCode).child("Players").child(uid).updateChildValues(["PlayerIndex" : index - 1])
                }
            }
            }
        }
    }
    
    
}
