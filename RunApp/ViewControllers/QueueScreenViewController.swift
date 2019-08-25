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
                print("No Data!!!")
                return
            }
            let num = value["PlayersAvailible"] as! Int
            if num >= 4 {
                self.ref.child("QueueLine").updateChildValues(["Deleting" : true])
            }
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    
    
    
    //TODO: If more than 4 players are ready
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
