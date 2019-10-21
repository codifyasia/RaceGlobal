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
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
