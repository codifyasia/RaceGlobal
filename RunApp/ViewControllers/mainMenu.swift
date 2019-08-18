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
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func QueueUp(_ sender: Any) {
        ref.child("QueueLine").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser!.uid)
        self.ref.child("QueueLine").child(Auth.auth().currentUser!.uid).setValue(["Position": 1, "Lobby" : 0])
        ref.child("QueueLine").updateChildValues(["PlayersAvailible" : 2])
//        lobbyReference.child(nextAvailibleLobby).child(Auth.auth().currentUser!.uid) //nextAvailibleLobby is an int that you convert into a string in which you pass it into the lobbies reference.
        //the name of the child has to only be the number so that later when you are on the players mobile device you just call the current lobby the player is in which is a integer. That way when there are like a lot of lobbies firebase doesn't have to loop through every single one and multipel games can go smoothly at once.
    }
    
    
    //in progress, dont edit
    @IBAction func getInQ(_ sender: Any) {
        let lobbyReference = Database.database().reference().child("Lobbies")
        lobbyReference.child("Lobby").observeSingleEvent(of: .value) { snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                guard let lobby = snap.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                if (lobby["numPlayers"] as! Int == 1) {
                    
                }
            }
        }
    }

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

}
