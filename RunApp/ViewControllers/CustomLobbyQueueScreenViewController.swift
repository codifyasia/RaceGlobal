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
    var counter  = 1
    @IBOutlet var stuff: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        stuff.text = "1"
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
                if numPlayers == 2 {
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
                    self.ref.child("QueueLine").observeSingleEvent(of: .value) { (snapshot) in
                        guard let val = snapshot.value as? NSDictionary else {
                            print("Nothing in QueueLine")
                            return
                        }
                        let lowestLobby = val["lowestLobby"] as! Int
                        self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).setValue([ "LobbyCode" : self.lobbyCode, "Lobby" : lowestLobby, "id" : Auth.auth().currentUser!.uid, "Distance" : 0, "PlayerIndex" : currentPIndex])
                        self.removePlayer(num : numPlayers, lowestLob: lowestLobby)

                    }
                    
                    self.performSegue(withIdentifier: "goToRaceScreen", sender: self)
                    if (numPlayers == 0) {
                        self.ref.child("CustomLobbies").child(self.lobbyCode).removeValue()
                    }
                    self.timer.invalidate()
                    
                }
            }
            
            
        }
    }
    
    func removePlayer(num : Int, lowestLob : Int) {
        if num > 1 {
        ref.child("CustomLobbies").child(lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).removeValue()
        ref.child("CustomLobbies").child(lobbyCode).updateChildValues(["numPlayers" : num - 1])
            if (num == 2) {
                ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : false])
            }
        }
        else {
            ref.child("QueueLine").updateChildValues(["lowestLobby" : lowestLob + 1])
            ref.child("CustomLobbies").child(lobbyCode).removeValue()
            ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : true])
        }
    }
    
    @objc func change() {
        
        if (counter == 1) {
            stuff.text = "2"
            counter = 2
        } else if (counter == 2) {
            stuff.text = "3"
            counter = 3
        } else if (counter == 3) {
            counter = 1
            stuff.text = "1"
            check()
        }
    }
    
    
}

