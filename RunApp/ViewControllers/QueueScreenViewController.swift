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
    
    override func viewDidLoad() {
        //Set everything up and start everything
        ref = Database.database().reference()
        searchingLabel.text = "Searching for Players"
        super.viewDidLoad()
        startAnimation()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(QueueScreenViewController.change), userInfo: nil, repeats: true)

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
            let numPlayers = value["PlayersAvailible"] as! Int
            if (!deleting) {
                if numPlayers >= 4 {
                    self.ref.child("QueueLine").updateChildValues(["Deleting" : true])
                    self.ref.child("QueueLine").updateChildValues(["Index" : 1])
                }
            }
            else {
                let index = value["Index"] as! Int
                self.ref.child("QueueLine").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snap) in
                    // Get user value
                    guard let dict = snap.value as? NSDictionary else {
                        print("No Dataaa!!!")
                        return
                    }
                    let position = dict["Position"] as! Int
                    if (position == index && index == 4) {
                        self.ref.child("QueueLine").child(Auth.auth().currentUser!.uid).removeValue()
                        self.ref.child("QueueLine").updateChildValues(["Deleting" : false])
                        self.removePlayers(num : numPlayers)
                    }
                    else if (position == index) {
                        self.ref.child("QueueLine").child(Auth.auth().currentUser!.uid).removeValue()
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
                self.ref.child("QueueLine").child("Players").child(uid).updateChildValues(["Position" : position-4])
                self.ref.child("QueueLine").updateChildValues(["PlayersAvailible" : num-4])
            }
        }
    }
    
    
    
    
    
    
    
    
    //TODO: Animations
    func startAnimation() {
        animationView.animation = Animation.named("world")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
