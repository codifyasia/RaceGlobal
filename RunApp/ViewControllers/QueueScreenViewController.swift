//
//  QueueScreenViewController.swift
//  RunApp
//
//  Created by Michael Peng on 8/24/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class QueueScreenViewController: UIViewController {
    
    //Animation
    @IBOutlet weak var animationView: AnimationView!
    //Timer
    var timer = Timer()
    //Dot counter
    var dotCounter = 0
    //Search Label Outlet
    @IBOutlet weak var searchingLabel: UILabel!
    //Database Reference
    var ref: DatabaseReference!
    var name:String = ""
    var currentLobby : Int!
    override func viewDidLoad() {
        //view.setGradientBackground(colorOne: Colors.veryDarkGrey, colorTwo: Colors.black, property: "none")
        //Set everything up and start everything
        
        ref = Database.database().reference()
        searchingLabel.text = "Searching for Players"
        super.viewDidLoad()
        startAnimation()
        retrieveData()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(QueueScreenViewController.change), userInfo: nil, repeats: true)
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    //TODO: Checking Function
    func check() {
        ref.child("QueueLine").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            let deleting =  value["Deleting"] as! Bool
            //If deleting is true, then queue will need to delete players from queue
            let numPlayers = value["PlayersAvailible"] as! Int
            //Number of players that is in the queue
            let numSegued = value["numSegued"] as! Int
            //
            let lowestLobby = value["lowestLobby"] as! Int
            //the lowest lobby number
            let index = value["Index"] as! Int  
            if (!deleting) {
                if numPlayers >= 2 {
                    //if theres more than 4 players, ready, start the deletion process
                    self.ref.child("QueueLine").updateChildValues(["Deleting" : true])
                    self.ref.child("QueueLine").updateChildValues(["Index" : 1])
                }
            }
            else {
                self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snap) in
                    // Get user value
                    guard let dict = snap.value as? NSDictionary else {
                        print("No Dataaa!!!")
                        return
                    }
                    let position = dict["Position"] as! Int
                    self.currentLobby = lowestLobby
                    if (position == 2 && index == 2) {
                        //the end of the queue, it will stop deleting after 4 ppl have been deleted
                        self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).removeValue()
                        self.ref.child("QueueLine").updateChildValues(["Deleting" : false])
                        self.removePlayers(num : numPlayers)
                        self.ref.child("RacingPlayers").child("Players").child("\(self.currentLobby!)").child(Auth.auth().currentUser!.uid).setValue([ "Lobby" : lowestLobby, "id" : Auth.auth().currentUser!.uid, "Distance" : 0, "PlayerIndex" : numSegued, "Username" : self.name])
                        self.ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : true])
                        self.ref.child("QueueLine").updateChildValues(["numSegued" : 0])
                        self.ref.child("QueueLine").updateChildValues(["lowestLobby" : lowestLobby+1])
                        self.ref.child("QueueLine").updateChildValues(["Index" : 1])
                        print("Index \(index)" )
                        self.performSegue(withIdentifier: "toRaceScreen", sender: self)
                        print("segue player 4")
                        
                    }
                    else if (position == index) {
                        
                        self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).removeValue()
                        //removes the player from the queue
                        self.ref.child("QueueLine").updateChildValues(["Index" : index+1])
                        //increments the index so that the next person can be deleted from the queue (so that they entire this if statement or the one above)
                        self.ref.child("RacingPlayers").child("Players").child("\(self.currentLobby!)").child(Auth.auth().currentUser!.uid).setValue([ "Lobby" : lowestLobby, "id" : Auth.auth().currentUser!.uid, "Distance" : 0, "PlayerIndex" : numSegued, "Username" : self.name])
                        //adds a player to the players node in racingplayers and sets its values
                        self.ref.child("RacingPlayers").updateChildValues(["EveryoneIn" : false])
                        self.ref.child("QueueLine").updateChildValues(["numSegued" : numSegued + 1])
                        //makes numSegued one more than it was previously, so that equal player has a unique index for PlayerIndex.
                        self.ref.child("QueueLine").updateChildValues(["lowestLobby" : lowestLobby])
                        //this shit is pretty much useless.
                        
                        print("Index \(index)")
                        //performs a segue.
                        self.performSegue(withIdentifier: "toRaceScreen", sender: self)
                        print("segue not player")
                        
                    }
                }) { (error) in
                    print("error:\(error.localizedDescription)")
                }
            }
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    
    
    
    //TODO: If more than 4 players are ready
    func removePlayers(num : Int) -> Void {
        ref.child("QueueLine").child("Players").observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                let uid = value["id"] as! String
                let position = value["Position"] as! Int
                self.ref.child("QueueLine").child("Players").child(uid).updateChildValues(["Position" : position-2])
            }
        }
        ref.child("QueueLine").updateChildValues(["PlayersAvailible" : num-2])
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        ref.child("QueueLine").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            let numPlayers = value["PlayersAvailible"] as! Int
            self.ref.child("QueueLine").updateChildValues(["PlayersAvailible" : numPlayers - 1])
            
            self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot1) in
                guard let value1 = snapshot1.value as? NSDictionary else {
                    print("No Datttta!!!!!!")
                    return
                }
                self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).removeValue()
                let position = value1["Position"] as! Int
                
                self.fixLine(pos: position)
                
            })
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        
        
    }
    
    
    func fixLine(pos : Int) {
        ref.child("QueueLine").child("Players").observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                let uid = value["id"] as! String
                let position = value["Position"] as! Int
                print("\(pos) \(position)")
                if position > pos {
                    self.ref.child("QueueLine").child("Players").child(uid).updateChildValues(["Position" : position-1])
                }
            }
        }
    }
    
    
    //TODO: Animations
    func startAnimation() {
        animationView.animation = Animation.named("world")
        animationView.frame.size.height *= 2
        animationView.frame.size.width *= 1.5
        animationView.loopMode = .loop
        animationView.play()
        // Finished code
    }
    
    //TODO:Timer Intervals
    @objc func change() {
        if dotCounter == 3 {
            check()
            dotCounter = 0
            searchingLabel.text = "Searching for Players"
        }
        else {
            searchingLabel.text = searchingLabel.text! + " ."
            dotCounter = dotCounter+1
        }
        
    }
    
    func retrieveData() {
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            self.name = value["Username"] as! String
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRaceScreen" {
            let destinationVC = segue.destination as! DistanceChoose
            destinationVC.currentLobby = self.currentLobby
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
