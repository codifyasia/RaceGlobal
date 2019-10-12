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
    var timer = Timer()
//    @IBOutlet weak var stuff: UILabel!
    var counter  = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(CustomLobbyQueueViewController.change), userInfo: nil, repeats: true)
        
        definesPresentationContext = true
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
            self.timer.invalidate()
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
    
    func check() {
        print("gay")
        ref.child("CustomLobbies").child(lobbyCode).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? NSDictionary else {
                    print("NO DATTAA!!!")
                    return
            }
            let numPlayers = data["numPlayers"] as! Int
            let deleting = data["Deleting"] as! Bool
            if (!deleting) {
                //MIGHT HAVE TO CHANGE NEXT LINE IF MORE THAN 4 PLAYERS
                if numPlayers == 4 {
                    self.ref.child("CustomLobbies").child(self.lobbyCode).updateChildValues(["Deleting" : true])
                }
            }
            else {
                self.ref.child("CustomLobbies").child(self.lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snap) in
                    guard let value = snap.value as? NSDictionary else {
                            print("No DATA")
                            return
                    }
                
                let currentPIndex = value["PlayerIndex"] as! Int
                self.removePlayer(num : numPlayers)
                    self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).setValue([ "Lobby" : self.lobbyCode, "id" : Auth.auth().currentUser!.uid, "Distance" : 0, "PlayerIndex" : currentPIndex])
                    if (currentPIndex == 4) {
                        self.ref.child("CustomLobbies").child(self.lobbyCode).removeValue()
                    }
                    self.performSegue(withIdentifier: "goToRaceScreen", sender: self)
                    
                }
            }
            
            
        }
    }
    
    func removePlayer(num : Int) {
        if num > 1 {
        ref.child("CustomLobbies").child(lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).removeValue()
        ref.child("CustomLobbies").child(lobbyCode).updateChildValues(["numPlayers" : num - 1])
        }
        else {
            ref.child("CustomLobbies").child(lobbyCode).removeValue()
        }
    }
    
    @objc func change() {
        
//        if (stuff.text == "1") {
//            stuff.text = "2"
//        } else if (stuff.text == "2") {
//            stuff.text = "3"
//        } else if (stuff.text == "3") {
//            stuff.text = "1"
//            check()
//        }
        if (counter == 3) {
            check()
            counter = 1
        } else {
            counter += 1
        }
    }
    
    
}

