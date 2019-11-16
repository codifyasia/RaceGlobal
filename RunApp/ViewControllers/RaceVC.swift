//
//  RaceVC.swift
//  RunApp
//
//  Created by Ricky Wang on 11/11/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//
//still need to do win condition
import UIKit
import Firebase
import CoreLocation
import TextFieldEffects
import Lottie
import MBCircularProgressBar

class RaceVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    //location
    let locationManager = CLLocationManager()
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var goalDistance:Double = 0
    var travelledDistance: Double = 0
    //firebase
    var currentLobby: Int!
    var enemyName: String = ""
    var playerName: String = ""
    //fires at very short intervals
    var updateTimer = Timer()
    //UI linking
    @IBOutlet weak var enemyProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var playerProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var traveledDistanceLabel: UILabel!
    @IBOutlet weak var goalDistanceLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EnemyLabel: UILabel! // rename these
    var name: String!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        ref = Database.database().reference()
        retrieveData()
        setUpLabels()
        StartEverything()
        updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(RaceVC.updateAll), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(travelledDistance)
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            //            var speed: CLLocationSpeed = CLLocationSpeed()
            if startLocation == nil {
                startLocation = locations.first
            } else {
                if (travelledDistance >= goalDistance) {
                    locationManager.stopUpdatingLocation()
                }
                let lastLocation = locations.last as! CLLocation
                if (startLocation.distance(from: lastLocation) > 4) {
                    let distance = startLocation.distance(from: lastLocation)
                    startLocation = lastLocation
                    travelledDistance += distance
                }
            }
        }
    }
    func retrieveData() {
        print("Started retrieving data")
       ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { snapshot in
            print("retrieve data: " + String(snapshot.childrenCount))
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("could not collect label data")
                    return
                }
                let uid = value["id"] as! String
                let username = value["Username"] as! String
                
                if (uid == Auth.auth().currentUser!.uid) {
                    self.goalDistance = value["SelectedDist"] as! Double //might be fucked
                    self.NameLabel.text = username
                    self.name = username

                } else {
                    self.EnemyLabel.text = username
                }
            }
            print("Goal Distance: " + String(self.goalDistance))
        }
        print("finished retrieving data")
    }
    @objc func updateAll() {
        updateSelfDistToFirebase()
        self.traveledDistanceLabel.text = String(travelledDistance)
        ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { snapshot in
            print("updateAll: " + String(snapshot.childrenCount))
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                let uid = value["id"] as! String
                let distanceRan = value["Distance"] as! Double
                
                if (uid == Auth.auth().currentUser!.uid) {
                    
                    UIView.animate(withDuration: 0.5) {
                        self.playerProgressBar.value = CGFloat(self.travelledDistance / self.goalDistance) * 100
                    }
                } else {
                    if (distanceRan > self.goalDistance) {
                        self.enemyProgressBar.isHidden = true
                    } // enemy win condition
                    UIView.animate(withDuration: 0.5) {
                        self.enemyProgressBar.value = CGFloat(distanceRan / self.goalDistance) * 100
                    }
            
                }
            }
        }
        checkIfPlayerWon()
    }
    func StartEverything() {
        print("started starting everything")
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        print("ended starting everything")
    }
    func setUpLabels() {
        print("started setting up labels")
        playerProgressBar.value = 0
        enemyProgressBar.value = 0
        goalDistanceLabel.text = String(goalDistance)
        traveledDistanceLabel.text = String(travelledDistance)
        print("ended setting up labels")
    }
    func updateSelfDistToFirebase() {
        ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues([ "Distance" : travelledDistance])
    }
    
    func checkIfPlayerWon() {
        if (travelledDistance > goalDistance) {
            ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { (snapshot) in
                if !snapshot.hasChild("Winner") {
                    self.ref.child("RacingPlayers").child("Players").child("\(self.currentLobby!)").updateChildValues(["Winner" : Auth.auth().currentUser!.uid])
                    self.performSegue(withIdentifier: "toWinScreen", sender: self)
                } else {
                    self.performSegue(withIdentifier: "goToLoseScreen", sender: self)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLoseScreen" {
            let destinationVC = segue.destination as! LoseScreen
            destinationVC.currentLobby = self.currentLobby
        }
        if (segue.identifier == "toWinScreen") {
            let destinationVC = segue.destination as! WinScreen
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
