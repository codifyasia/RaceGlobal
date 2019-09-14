//
//  raceScreen.swift
//  RunApp
//
//  Created by Ricky Wang on 8/5/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import TextFieldEffects
import GTProgressBar
import Lottie

class raceScreen: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    //TODO: LocationServices
    let locationManager = CLLocationManager()
    var startLocation:CLLocation!
    var lastLocation:CLLocation!
    var traveledDistance:Double = 0
    
    //TODO: Timer
    var seconds:Int = 3
    var timer = Timer()
    @IBOutlet weak var countdownAnimation: AnimationView!
    //TODO: ProgressBar
    @IBOutlet weak var progressBar1: GTProgressBar!
    @IBOutlet weak var progressBar2: GTProgressBar!
    @IBOutlet weak var progressBar3: GTProgressBar!
    @IBOutlet weak var progressBar4: GTProgressBar!
    //TODO: Labels
    var spd: Float = 0.0
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    var playerIndex : Int = 0
    var playerLobby : Int = 0
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set everything up and start everything
        ref = Database.database().reference()
        //TODO: Timer
        startAnimation()
        retrieveData()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(raceScreen.timerCounter), userInfo: nil, repeats: true)
        //TODO: ProgressBar
        progressBar1.isHidden = true
        progressBar2.isHidden = true
        //TODO: Location Services
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    //TODO: Timer
    @objc func timerCounter() {
        seconds = seconds - 1
        if (seconds == 0) {
            timer.invalidate()
            progressBar1.isHidden = false
            progressBar2.isHidden = false
            //do other stuff
        }
    }
    //TODO: LocationServices
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            var speed: CLLocationSpeed = CLLocationSpeed()
            speed = locationManager.location!.speed
            spd = Float(speed)
            if startLocation == nil {
                startLocation = locations.first
            } else {
                let lastLocation = locations.last as! CLLocation
                if (startLocation.distance(from: lastLocation) > 4) {
                    updateAllProgress(travelledDist: Int(traveledDistance))
                    let distance = startLocation.distance(from: lastLocation)
                    startLocation = lastLocation
                    traveledDistance += distance
                }
            }
        }
    }
    //TODO: Labels
    func updateAllProgress(travelledDist: Int) {
        progressBar1.progress = CGFloat(traveledDistance / 100)
        speedLabel.text = String(spd)
        distanceLabel.text = String(traveledDistance)
        updateRivalProgressBars(travelledD: travelledDist)
    }
    func startAnimation() {
        countdownAnimation.animation = Animation.named("8803-simple-countdown")
        countdownAnimation.play()
    }
    
    // basically right now the firebase RacingPlayers section has "id" "Distance" "Lobby" "PlayerIndex". PlayerIndex is to figure out which progress bar to update. Lobby is for checking if the player's lobby is the same one as the player who's currently signed in.
    func updateRivalProgressBars(travelledD : Int) {
        self.ref.child("RacingPlayers").child("Players").child(Auth.auth().currentUser!.uid).updateChildValues([ "Distance" : travelledD])
        ref.child("RacingPlayers").child("Players").observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                let lobbyNum = value["Lobby"] as! Int
                let uid = value["id"] as! String
                let index = value["PlayerIndex"] as! Int
                let distanceRan = value["Distance"] as! Int
            }
        }
    }
    
    func retrieveData() {
        ref.child("RacingPlayers").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            self.playerIndex = value["PlayerIndex"] as! Int
            self.playerLobby = value["Lobby"] as! Int
        }
    }
}
