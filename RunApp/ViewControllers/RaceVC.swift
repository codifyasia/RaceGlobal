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
import MapKit

class RaceVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    //location
    let locationManager = CLLocationManager()
    var startLocation:CLLocation!
    var prevLocation: CLLocation!
    var lastLocation: CLLocation!
    var goalDistance:Double = 0
    var travelledDistance: Double = 0
    let zoom : Double = 1000
    //firebase
    var currentLobby: Int!
    var enemyName: String = ""
    var playerName: String = ""
    //fires at very short intervals
    var updateTimer = Timer()
    var startTimer = Timer()
    var cdVal = 30
    var finalTime : Double!
    //UI linking
//    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var OptOutButton: UIButton!
    @IBOutlet weak var enemyProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var playerProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var traveledDistanceLabel: UILabel!
    @IBOutlet weak var goalDistanceLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EnemyLabel: UILabel! // rename these
    @IBOutlet weak var cdLabel: UILabel!
    var name: String!
//    @IBOutlet weak var progressLabel: UILabel!
    
    
    @IBOutlet weak var mapView: MKMapView!
    //Timer
    var hundreds : Int = 0
    var tens : Int = 0
    var ones : Int = 0
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.requestAlwaysAuthorization()
        ref = Database.database().reference()
        
        cdLabel.text = String(cdVal)
        retrieveData()
        setUpLabels()
        hideAll()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        print("Location being updated")
        startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RaceVC.startTimerChange), userInfo: nil, repeats: true)
//        StartEverything()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func expandMap(_ sender: Any) {
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            self.mapView?.transform = CGAffineTransform(scaleX: 2, y: 5)
//            , completion: {(_ finished: Bool) -> Void in
//            UIView.animate(withDuration: 2.0, animations: {() -> Void in
//                self.mapView?.transform = CGAffineTransform(scaleX: 1, y: 1)
//            })
        })
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: zoom, longitudinalMeters: zoom)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (cdVal <= 0) {
            guard let location = locations.last else { return }
            print(cdVal)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: zoom, longitudinalMeters: zoom)
            mapView.setRegion(region, animated: true)
            if (location.horizontalAccuracy < 10) {
                //            var speed: CLLocationSpeed = CLLocationSpeed()
                if startLocation == nil {
                    startLocation = locations.first!
                } else {
                    if (travelledDistance >= goalDistance) {
                        finalTime = Double(hundreds) * 60.0
                        finalTime += Double(tens)
                        finalTime += Double(ones) / 100.0
                        ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").child(Auth.auth().currentUser!.uid).updateChildValues(["Time": finalTime])
                        updateTimer.invalidate()
                        locationManager.stopUpdatingLocation()
                        checkIfPlayerWon()
                    }
                    let lastLocation = locations.last as! CLLocation
                    let distance = startLocation.distance(from: lastLocation)
                    startLocation = lastLocation
                    travelledDistance += distance
                    updateAll()
                }
            }
        }
           
//        Ricky's Code
//        if (location.horizontalAccuracy > 0) {
//            //            var speed: CLLocationSpeed = CLLocationSpeed()
//            if startLocation == nil {
//                startLocation = locations.first
//            } else {
//                if (travelledDistance >= goalDistance) {
//                    checkIfPlayerWon()
//                    locationManager.stopUpdatingLocation()
//                }
//                let lastLocation = locations.last as! CLLocation
//                if (startLocation.distance(from: lastLocation) > 4) {
//                    let distance = startLocation.distance(from: lastLocation)
//                    startLocation = lastLocation
//                    travelledDistance += distance
//                    updateAll()
//                }
//            }
//        }
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
            
            
//            guard let val123 = snapshot.value as? NSDictionary else {
//
//                return
//            }
            
//            let winnerID = val123["Winner"] as! String
            
            
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
        checkOtherStatus()
    }
    
    func checkOtherStatus() {
        print("entered checking other status")
        ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild("Winner") {
//                self.statusLabel.text = "opponent alr won"
            }
            if snapshot.hasChild("OptOut") {
//                self.statusLabel.text = "opponent opted out"
            }
        }
    }
    
    func StartEverything() {
        showAll()
        startTimer.invalidate()
        cdLabel.isHidden = true
        print("started starting everything")
        print("ended starting everything")
        updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(RaceVC.changeTimer), userInfo: nil, repeats: true)
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
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
        print("checking if player won")
        if (travelledDistance >= goalDistance) {
            ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { (snapshot) in
                if !snapshot.hasChild("Winner") {
                    self.ref.child("RacingPlayers").child("Players").child("\(self.currentLobby!)").updateChildValues(["Winner" : Auth.auth().currentUser!.uid])
//                    self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).child("Previous").childByAutoId().updateChildValues(["dist":self.travelledDistance, "won": true, "date": "yote"])
                    self.performSegue(withIdentifier: "toWinScreen", sender: self)
                } else {
//                    self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).child("Previous").childByAutoId().updateChildValues(["dist":self.travelledDistance, "won": false, "date": "yote"])
                    self.performSegue(withIdentifier: "goToLoseScreen", sender: self)

                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLoseScreen" {
            let destinationVC = segue.destination as! LoseScreen
            destinationVC.currentLobby = self.currentLobby
            destinationVC.time.text = "\(hundreds):\(tens):\(ones)"
            destinationVC.dist = travelledDistance
        }
        if (segue.identifier == "toWinScreen") {
            let destinationVC = segue.destination as! WinScreen
            destinationVC.currentLobby = self.currentLobby
            destinationVC.time.text = "\(hundreds):\(tens):\(ones)"
            destinationVC.dist = travelledDistance
        }
    }
    
    
    @objc func changeTimer() {
        
        ones = ones + 1
        if (ones == 100) {
            ones = 0
            tens = tens + 1
        }
        if (tens == 60) {
            tens = 0
            hundreds = hundreds + 1
        }
        
        
        
        
        goalDistanceLabel.text = "\(hundreds):\(tens):\(ones)"
    }
    @IBAction func OptOutPressed(_ sender: Any) {
        ref.child("RacingPlayers").child("Players").child("\(currentLobby!)").observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.hasChild("OptOut") {
                self.ref.child("RacingPlayers").child("Players").child("\(self.currentLobby!)").updateChildValues(["OptOut" : Auth.auth().currentUser!.uid])
                self.locationManager.stopUpdatingLocation()
                self.performSegue(withIdentifier: "OptOut", sender: self)
            } else {
                self.ref.child("RacingPlayers").child("Players").child("\(self.currentLobby!)").removeValue()
                self.locationManager.stopUpdatingLocation()
                self.performSegue(withIdentifier: "OptOut", sender: self)
            }
        }
    }
    
    
    func hideAll() {
//        statusLabel.isHidden = true
        OptOutButton.isHidden = true
        traveledDistanceLabel.isHidden = true
        enemyProgressBar.isHidden = true
        playerProgressBar.isHidden = true
        goalDistanceLabel.isHidden = true
        NameLabel.isHidden = true
        EnemyLabel.isHidden = true
//        progressLabel.isHidden = true
        mapView.isHidden = true
//        expandMap.isHidden = true
        
    }
    
    func showAll() {
//        statusLabel.isHidden = false
        OptOutButton.isHidden = false
        traveledDistanceLabel.isHidden = false
        cdLabel.isHidden = false
        enemyProgressBar.isHidden = false
        playerProgressBar.isHidden = false
        goalDistanceLabel.isHidden = false
        NameLabel.isHidden = false
        EnemyLabel.isHidden = false
//        progressLabel.isHidden = false
        mapView.isHidden = false
//        expandMap.isHidden = false
    }
    
    @objc func startTimerChange() {
        if (cdVal == 0) {
            StartEverything()
        }
        
        cdVal -= 1
        cdLabel.text = String(cdVal)
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
