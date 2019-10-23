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
    
    @IBOutlet weak var animationView: AnimationView!
    
    var lobbyCode = ""
    var ref : DatabaseReference!
    var timer = Timer()
    var counter  = 1
    var currentLobby : Int!
    @IBOutlet var stuff: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        stuff.text = "1"
        ref = Database.database().reference()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(CustomLobbyQueueViewController.change), userInfo: nil, repeats: true)
        startAnimation()
        definesPresentationContext = true
    }
    
    
    func startAnimation() {
        animationView.animation = Animation.named("map")
        animationView.loopMode = .loop
        animationView.play()
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
                if numPlayers == 1 {
                    self.ref.child("CustomLobbies").child(self.lobbyCode).removeValue()
                }
                self.fixLine(pos : index)
            }
            self.timer.invalidate()
            self.performSegue(withIdentifier: "customToMain", sender: self)
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
                print("deleting")
                self.ref.child("QueueLine").observeSingleEvent(of: .value) { (snapshot) in
                guard let val = snapshot.value as? NSDictionary else {
                    print("Nothing in QueueLine")
                    return
                }
                let lowestLobby = val["lowestLobby"] as! Int
                    self.currentLobby = lowestLobby
                self.ref.child("CustomLobbies").child(self.lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snap) in
                    guard let value = snap.value as? NSDictionary else {
                            print("No DATA")
                            return
                    }
                
                    let currentPIndex = value["PlayerIndex"] as! Int
                    let userName = value["Username"]
                    self.ref.child("RacingPlayers").child("Players").child("\(self.currentLobby!)").child(Auth.auth().currentUser!.uid).setValue([ "LobbyCode" : self.lobbyCode, "Lobby" : lowestLobby, "id" : Auth.auth().currentUser!.uid, "Distance" : 0, "PlayerIndex" : currentPIndex, "Username" : userName])
                        self.removePlayer(num : numPlayers, lowestLob: lowestLobby, playerIndex: currentPIndex)

                    }
                    
                    
                }
            }
            
            
            
        }
    }
    
    func removePlayer(num : Int, lowestLob : Int, playerIndex : Int) -> Void{
        if (playerIndex == 0 && num == 2) {
            print("remove playerIndex : 0")
            ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : false])
            ref.child("CustomLobbies").child(lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).removeValue()
            ref.child("CustomLobbies").child(lobbyCode).updateChildValues(["numPlayers" : 1])
            self.timer.invalidate()
            self.performSegue(withIdentifier: "goToRaceScreen", sender: self)
            
            
        } else if (playerIndex == 1 && num == 1) {
            print("remove playerIndex : 1")
            ref.child("CustomLobbies").child(lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).removeValue()
            self.ref.child("CustomLobbies").child(self.lobbyCode).removeValue()
            self.ref.child("QueueLine").updateChildValues(["lowestLobby" : lowestLob + 1])
            self.ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : true])
            self.ref.child("CustomLobbies").child(self.lobbyCode).removeValue()
            self.timer.invalidate()
            self.performSegue(withIdentifier: "goToRaceScreen", sender: self)
            
        }
        
//        if num > 1 {
//            print("The number of players before next removal is")
//            print(num)
//            if (num == 2) {
//                ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : false])
//            }
//            ref.child("CustomLobbies").child(lobbyCode).child("Players").child(Auth.auth().currentUser!.uid).removeValue()
//            ref.child("CustomLobbies").child(lobbyCode).updateChildValues(["numPlayers" : num - 1])
//
//        }
//        else {
//            ref.child("QueueLine").updateChildValues(["lowestLobby" : lowestLob + 1])
//            ref.child("CustomLobbies").child(lobbyCode).removeValue()
//            ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : true])
//        }

    }
    @objc func change() {
        
        if (counter == 1) {
            stuff.text = "Waiting for Players ."
            counter = 2
        } else if (counter == 2) {
            stuff.text = "Waiting for Players . ."
            counter = 3
        } else if (counter == 3) {
            stuff.text = "Waiting for Players . . ."
            counter = 1
            check()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRaceScreen" {
            let destinationVC = segue.destination as! DistanceChoose
            destinationVC.currentLobby = self.currentLobby
        }
    }
    
    
}

        


