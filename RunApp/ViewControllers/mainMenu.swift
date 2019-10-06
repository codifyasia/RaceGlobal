//
//  mainMenu.swift
//  RunApp
//
//  Created by Ricky Wang on 8/10/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class mainMenu: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var helloLabel: UILabel!
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var RunningAnimation: AnimationView!
    @IBOutlet weak var queueButton: UIButton!
    @IBOutlet weak var customLobbyButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        buttonAdjustments()
        RunningAnimation.layer.cornerRadius = 20
        RunningAnimation.layer.shadowColor = UIColor.black.cgColor
        RunningAnimation.layer.shadowRadius = 40
        RunningAnimation.layer.shadowOpacity = 0.5
        RunningAnimation.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.navigationController!.navigationBar.barStyle = .blackOpaque
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = Database.database().reference()
        
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        guard let value = snapshot.value as? NSDictionary else {
            print("No Data!!!!!!")
            return
            }
            
            var name: String = value["FirstName"] as! String
            
            self.helloLabel.text = "Hello \(name)"
            
            
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func QueueUp(_ sender: Any) {
//        ref.child("QueueLine").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser!.uid)
        ref.child("QueueLine").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let amount = value["PlayersAvailible"] as! Int
            print(amount)
            
            self.ref.child("QueueLine").updateChildValues(["PlayersAvailible" : amount+1])
            self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).setValue(["Position": amount+1, "Lobby" : 0, "id" : Auth.auth().currentUser!.uid])
            print("joined Queue")
            
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    //Removing Thing
    func removePlayers() {
        self.ref.child("QueueLine").updateChildValues(["PlayersAvailible" : 0])
        self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).removeValue()
    }
    
    
    //in progress, dont edit
//        func getInQ(_ sender: Any) {
//        let lobbyReference = Database.database().reference().child("Lobbies")
//        lobbyReference.child("Lobby").observeSingleEvent(of: .value) { snapshot in
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                guard let lobby = snap.value as? NSDictionary else {
//                    print("No Data!!!")
//                    return
//                }
//                if (lobby["numPlayers"] as! Int == 1) {
//
//                }
//            }
//        }
//    }

    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("log out success")
        } catch {
            print(error)
        }
        performSegue(withIdentifier: "goBackToSignUp", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func test(_ sender: Any) {
        self.ref.child("QueueLine").updateChildValues(["Deleting" : false])
        removePlayers()
    }
    func buttonAdjustments() {
        queueButton.layer.cornerRadius = queueButton.frame.height / 2
        statisticsButton.layer.cornerRadius = statisticsButton.frame.height / 2
        customLobbyButton.layer.cornerRadius = customLobbyButton.frame.height / 2
        
        queueButton.layer.shadowColor = UIColor.black.cgColor
        queueButton.layer.shadowRadius = 3;
        queueButton.layer.shadowOpacity = 0.5;
        queueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        customLobbyButton.layer.shadowColor = UIColor.black.cgColor
        customLobbyButton.layer.shadowRadius = 3;
        customLobbyButton.layer.shadowOpacity = 0.5;
        customLobbyButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        statisticsButton.layer.shadowColor = UIColor.black.cgColor
        statisticsButton.layer.shadowRadius = 3;
        statisticsButton.layer.shadowOpacity = 0.5;
        statisticsButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
    @IBAction func customLobbyPressed(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Custom Lobby", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create new custom lobby", style: .default) { (action) in
            let newAlert = UIAlertController(title: "Creating new custom lobby", message: "Enter your own lobby code", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "Done", style: .default) { (action) in
                if textField != nil {
                    print(textField.text)
                    
                self.ref.child("CustomLobbies").child(textField.text!).child("Players").child(Auth.auth().currentUser!.uid).setValue(["id" : Auth.auth().currentUser!.uid, "PlayerIndex" : 1])
                    self.ref.child("CustomLobbies").child(textField.text!).updateChildValues(["numPlayers" : 1])
                    //self.performSegue(withIdentifier: "goToQueueScreen", sender: self)
                }
                
            }
                newAlert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Lobby Code"
                textField = alertTextField
            }
            
            newAlert.addAction(doneButton)
            self.present(newAlert, animated: true, completion: nil)
            
        }
        
        let action2 = UIAlertAction(title: "Join custom lobby", style: .default) { (action) in
            let newAlert2 = UIAlertController(title: "Joining custom lobby", message: "Enter a code to join a custom lobby", preferredStyle: .alert)
            
            //self.ref.child("CustomLobbies").child("randomLobycode").child(Auth.auth().currentUser!.uid).setValue(["id" : Auth.auth().currentUser!.uid, "Distance" : 0, "PlayerIndex" : 1])
            let doneButton = UIAlertAction(title: "Done", style: .default) { (action) in
                //if textField != nil {
                    print(textField.text)
                
                self.ref.child("CustomLobbies").observeSingleEvent(of: .value) { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    
                    if (snapshot.hasChild(textField.text!)) {
                        self.ref.child("CustomLobbies").child(textField.text!).observeSingleEvent(of: .value) { (snapshot2) in
                            guard let value2 = snapshot2.value as? NSDictionary else {
                            print("No Data!!!")
                            return
                            }
                            let numPlayers = value2["numPlayers"] as! Int
                            print(numPlayers)
                            self.ref.child("CustomLobbies").child(textField.text!).child("Players").child(Auth.auth().currentUser!.uid).setValue(["id" : Auth.auth().currentUser!.uid, "PlayerIndex" : numPlayers + 1])
                            self.ref.child("CustomLobbies").child(textField.text!).updateChildValues(["numPlayers" : numPlayers + 1])
                            
                        }
                            
//                        self.ref.child("CustomLobbies").child(textField.text!).child("Players").child(Auth.auth().currentUser!.uid).setValue(["id" : Auth.auth().currentUser!.uid, "PlayerIndex" : 1 + numPlayers!])
//                        self.ref.child("CustomLobbies").child(textField.text!).updateChildValues(["numPlayers" : numPlayers! + 1])
                    } else {
                        let newAlert3 = UIAlertController(title: "Error", message: "The code you entered is invalid", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            //do nothing
                        }
                        
                        newAlert3.addAction(okAction)
                        self.present(newAlert3, animated: true, completion: nil)
                        
                    }
                    
                }
                    
                    
                //}
                
            }
            newAlert2.addTextField { (alertTextField) in
                alertTextField.placeholder = "Lobby Code"
                textField = alertTextField
            }
             newAlert2.addAction(doneButton)
            self.present(newAlert2, animated: true, completion: nil)

        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            //do nothing
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    func startAnimation() {
        RunningAnimation.animation = Animation.named("runninganimation")
        RunningAnimation.loopMode = .loop
        RunningAnimation.play()
        // Finished code
    }
}

