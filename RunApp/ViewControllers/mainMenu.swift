//
//  mainMenu.swift
//  RunApp
//
//  Created by Ricky Wang on 8/10/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class mainMenu: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barStyle = .black
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = Database.database().reference()
        
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
            
            self.ref.child("QueueLine").updateChildValues(["PlayersAvailible" : amount+1])
            self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).setValue(["Position": amount+1, "Lobby" : 0])
            print("gay")
            
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    //Removing Thing
    func removePlayers() {
        ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let currPosition = value["Position"] as! Int
            
            if currPosition <= 4 {
                //move into lobby
                self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).removeValue()
                self.ref.child("QueueLine").updateChildValues(["PlayersAvailible" : 0])
            }
            else {        self.ref.child("QueueLine").child("Players").child(Auth.auth().currentUser!.uid).updateChildValues(["Position" : currPosition-4])
            }
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
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
        removePlayers()
    }
}
