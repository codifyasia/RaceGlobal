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
    var canSegue:Bool = false
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 0])
        // Do any additional setup after loading the view.
    }
    @IBAction func mi1Pressed(_ sender: Any) { self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 1000])
    }
    @IBAction func mi2Pressed(_ sender: Any) {
        self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 2000])
    }
    @IBAction func mi3Pressed(_ sender: Any) {
        self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : 3000])
    }
    @objc func fireTimer() {
        var numSelectedDist = 0
        var newDistance = 0
        ref.child("RacingPlayers").child("Players").observeSingleEvent(of: .value) { snapshot in // might have not gone deep enough here, test tmrw
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                let dist = value["SelectedDist"] as! Int
                print("dist:" + String(dist))
                if (dist != 0) {
                    newDistance += dist
                    numSelectedDist += 1;
                    if (numSelectedDist >= 2) {
                        self.ready(newDistance1: newDistance)
                    }
                }
            }
        }
        //print("numSelectedDist: " + String(numSelectedDist))
    }

    func ready(newDistance1: Int) {
        self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).updateChildValues([ "SelectedDist" : newDistance1])
        //timer.invalidate()
        performSegue(withIdentifier: "goRaceScreen", sender: self)
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
