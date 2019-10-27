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
import CoreLocation

class mainMenu: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var helloLabel: UILabel!
    var textField = UITextField()
    
    var ref: DatabaseReference!
    var name:String = ""
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var RunningAnimation: AnimationView!
    @IBOutlet weak var queueButton: UIButton!
    @IBOutlet weak var customLobbyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //location request
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        signOutButton.tintColor = .white
        sideBarButton.tintColor = .white
        signOutButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 18.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],
                                             for: .normal)
        sideBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 18.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],
                                             for: .normal)
        startAnimation()
        buttonAdjustments()
        RunningAnimation.layer.cornerRadius = 20
        RunningAnimation.layer.shadowColor = UIColor.black.cgColor
        RunningAnimation.layer.shadowRadius = 40
        RunningAnimation.layer.shadowOpacity = 0.5
        RunningAnimation.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = Database.database().reference()
        
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            
            self.name = value["Username"] as! String
            
            self.helloLabel.text = "Hello \(self.name)!"
            
            
            
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
            self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).setValue(["Position": amount+1, "Lobby" : 0, "id" : Auth.auth().currentUser!.uid, "Username" : self.name])
            print("joined Queue")
            self.performSegue(withIdentifier: "goToQueue", sender: self)
            
            
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
        customLobbyButton.layer.cornerRadius = customLobbyButton.frame.height / 2
        queueButton.layer.cornerRadius = queueButton.frame.height / 2
        
        queueButton.layer.shadowColor = UIColor.black.cgColor
        queueButton.layer.shadowRadius = 3;
        queueButton.layer.shadowOpacity = 0.5;
        queueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        //queueButton.setGradientBackground(colorOne: Colors.veryDarkGrey, colorTwo: Colors.darkGrey, property: "corner")
        
        
        customLobbyButton.layer.shadowColor = UIColor.black.cgColor
        customLobbyButton.layer.shadowRadius = 3;
        customLobbyButton.layer.shadowOpacity = 0.5;
        customLobbyButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        //customLobbyButton.setGradientBackground(colorOne: Colors.veryDarkGrey, colorTwo: Colors.darkGrey, property: "corner")
        
        
        //statisticsButton.setGradientBackground(colorOne: Colors.veryDarkGrey, colorTwo: Colors.darkGrey, property: "corner")
    }
    
    func addFirstCustomPlayer() {
        self.ref.child("CustomLobbies").child(self.textField.text!).child("Players").child(Auth.auth().currentUser!.uid).setValue(["id" : Auth.auth().currentUser!.uid, "PlayerIndex" : 0, "Username" : self.name])
        self.ref.child("CustomLobbies").child(self.textField.text!).updateChildValues(["numPlayers" : 1])
        self.ref.child("CustomLobbies").child(self.textField.text!).updateChildValues(["Deleting" : false])
        self.performSegue(withIdentifier: "goToCustomQueue", sender: self)
    }
    
    @IBAction func customLobbyPressed(_ sender: UIButton) {
        
        //Popup alert
        let alert = UIAlertController(title: "Custom Lobby", message: "", preferredStyle: .alert)
        
        //Three Options - Option 1: Create a custom lobby code
        let action = UIAlertAction(title: "Create new custom lobby", style: .default) { (action) in
            let newAlert = UIAlertController(title: "Creating new custom lobby", message: "Enter your own lobby code", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "Done", style: .default) { (action) in
                if self.textField.text?.isEmpty ?? true {
                    let failAlert = UIAlertController(title: "Error", message: "Please enter in a valid code", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        
                    }
                    failAlert.addAction(okButton)
                    self.present(failAlert, animated : true, completion: nil)
                    return
                }
                if let text = self.textField.text {
                    //print(textField.text)
                    self.ref.observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.hasChild("CustomLobbies") {
                            print("CustomLobbies exist")
                            self.ref.child("CustomLobbies").observeSingleEvent(of: .value) { (snap) in
                                if snap.hasChild(self.textField.text!) {
                                    //
                                    //Code already in use
                                    let anotherAlert = UIAlertController(title: "Error", message: "Someone has already used this code", preferredStyle: .alert);
                                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                        return
                                    }
                                    
                                    anotherAlert.addAction(okAction)
                                    self.present(anotherAlert, animated: true, completion: nil)
                                    print("return")
                                    return
                                } else {
                                    self.addFirstCustomPlayer()
                                }
                            }
                        } else {
                            print("CustomLobbies does not exist")
                            self.addFirstCustomPlayer()
                        }
                    }
                    
                }
                
            }
            newAlert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Lobby Code"
                self.textField = alertTextField
            }
            
            newAlert.addAction(doneButton)
            self.present(newAlert, animated: true, completion: nil)
            
        }
        
        
        
        
        //Three Options - Option 2: Joining a custom lobby code
        let action2 = UIAlertAction(title: "Join custom lobby", style: .default) { (action) in
            let newAlert2 = UIAlertController(title: "Joining custom lobby", message: "Enter a code to join a custom lobby", preferredStyle: .alert)
            
            let doneButton = UIAlertAction(title: "Done", style: .default) { (action) in
                if self.textField != nil {
                    //print(textField.text)
                    
                    self.ref.child("CustomLobbies").observeSingleEvent(of: .value) { (snapshot) in
                        guard let value = snapshot.value as? NSDictionary else {
                            
                            let newAlert3 = UIAlertController(title: "Error", message: "The code you entered is invalid", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                //do nothing
                            }
                            
                            newAlert3.addAction(okAction)
                            self.present(newAlert3, animated: true, completion: nil)
                            return
                        }
                        
                        //If the code the user typed is in the data base, then proceed here
                        if (snapshot.hasChild(self.textField.text!)) {
                            self.ref.child("CustomLobbies").child(self.textField.text!).observeSingleEvent(of: .value) { (snapshot2) in
                                guard let value2 = snapshot2.value as? NSDictionary else {
                                    print("No Data!!!")
                                    return
                                }
                                let numPlayers = value2["numPlayers"] as! Int
                                print(numPlayers)
                                self.ref.child("CustomLobbies").child(self.textField.text!).child("Players").child(Auth.auth().currentUser!.uid).setValue(["id" : Auth.auth().currentUser!.uid, "PlayerIndex" : numPlayers, "Username" : self.name])
                                self.ref.child("CustomLobbies").child(self.textField.text!).updateChildValues(["numPlayers" : numPlayers + 1])
                                self.performSegue(withIdentifier: "goToCustomQueue", sender: self)
                                
                            }
                            
                        } else {
                            let newAlert3 = UIAlertController(title: "Error", message: "The code you entered is invalid", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                //do nothing
                            }
                            
                            newAlert3.addAction(okAction)
                            self.present(newAlert3, animated: true, completion: nil)
                            
                        }
                        
                    }
                }
                
            }
            newAlert2.addTextField { (alertTextField) in
                alertTextField.placeholder = "Lobby Code"
                self.textField = alertTextField
            }
            newAlert2.addAction(doneButton)
            self.present(newAlert2, animated: true, completion: nil)
            
        }
        
        //Three Options - Option 3: Cancel button (does nothing, alert should dismiss)
        let action3 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            //do nothing
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //sending Info about lobby code to CustomQueueScreenViewController
        if segue.identifier == "goToCustomQueue" {
            let customVC = segue.destination as! CustomLobbyQueueViewController
            customVC.lobbyCode = textField.text!
            
        }
    }
    
    func startAnimation() {
        RunningAnimation.animation = Animation.named("runninganimation")
        RunningAnimation.loopMode = .loop
        RunningAnimation.play()
        // Finished code
    }
}


