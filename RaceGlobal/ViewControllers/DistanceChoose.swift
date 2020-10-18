//
//  DistanceChoose.swift
//  RunApp
//
//  Created by Ricky Wang on 10/20/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class DistanceChoose: UIViewController {
    
    @IBOutlet weak var mile1: UIButton!
    @IBOutlet weak var mile2: UIButton!
    @IBOutlet weak var mile3: UIButton!
    var timer = Timer()
    var canSegue:Bool = false
    var ref: DatabaseReference!
    var currentLobby : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true); self.ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 0])
        // Do any additional setup after loading the view.
    }
    @IBAction func mi1Pressed(_ sender: Any) { self.ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 800])
    }
    @IBAction func mi2Pressed(_ sender: Any) {
        self.ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 1600])
    }
    @IBAction func mi3Pressed(_ sender: Any) {
        self.ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 3200])
    }
    @IBAction func mi4Pressed(_ sender: Any) {
        self.ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 5000])
    }
    @objc func fireTimer() {
        var numSelectedDist = 0
        var newDistance = 0
        ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { snapshot in
            if (snapshot.childrenCount >= 2) {// might have not gone deep enough here, test tmrw
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = rest.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    print("value:" + (value["Username"] as! String))
                    let dist = value["SelectedDist"] as! Int // this line is being run b4 everyone else segues, so it is null
                    //print("dist:" + String(dist))
                    if (dist != 0) {
                        newDistance += dist
                        numSelectedDist += 1;
                        if (numSelectedDist >= 2) {
                            self.ready(newDistance1: newDistance)
                        }
                    }
                }
            }
        }
        //print("numSelectedDist: " + String(numSelectedDist))
    }
    
    func ready(newDistance1: Int) {
        self.ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : newDistance1 / 2])
        timer.invalidate()
        performSegue(withIdentifier: "goRaceScreen", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goRaceScreen" {
            let destinationVC = segue.destination as! RaceVC
            destinationVC.currentLobby = currentLobby
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
