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

class raceScreen: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    //TODO: LocationServices
    let locationManager = CLLocationManager()
    var startLocation:CLLocation!
    var lastLocation:CLLocation!
    var traveledDistance:Double = 0
    
    //TODO: Timer
    var seconds:Int = 5
    var timer = Timer()
    @IBOutlet weak var timerLabel: UILabel!
    //TODO: ProgressBar
    @IBOutlet weak var progressBar1: GTProgressBar!
    @IBOutlet weak var progressBar2: GTProgressBar!
    //TODO: Labels
    var spd: Float = 0.0
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(raceScreen.timerCounter), userInfo: nil, repeats: true)
        timerLabel.text = String(seconds)
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
            traveledDistance = 0
            distanceLabel.text = String(traveledDistance)
            //do other stuff
        }
        timerLabel.text = String(seconds)
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
                    updateAllProgress()
                    let distance = startLocation.distance(from: lastLocation)
                    startLocation = lastLocation
                    traveledDistance += distance
                }
            }
        }
    }
    //TODO: Labels
    func updateAllProgress() {
        progressBar1.progress = CGFloat(traveledDistance / 100)
        speedLabel.text = String(spd)
        distanceLabel.text = String(traveledDistance)
    }
}
