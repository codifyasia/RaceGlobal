//
//  InTrialViewController.swift
//  RunApp
//
//  Created by Michael Peng on 11/9/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import MBCircularProgressBar
import CoreLocation

class InTrialViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    //Firebase
    var ref: DatabaseReference!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    //Timer
    var timer  = Timer()
    var hundreds : Int = 0
    var tens : Int = 0
    var ones : Int = 0
    
    var started : Bool = false
    
    
    //distances
    let locationManager = CLLocationManager()
    var startLocation:CLLocation!
    var lastLocation:CLLocation!
    var traveledDistance:Double = 0
    var dist : Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        ref = Database.database().reference()
        buttonAdjustments()
        setDistance()
    }
    
    @IBAction func startPressed(_ sender: Any) {
        if (!started) {
            locationManager.delegate = self
            startButton.setTitle("Pause", for: .normal)
            started = true
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(InTrialViewController.changeTimer), userInfo: nil, repeats: true)
            locationManager.desiredAccuracy=kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        else {
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            started = false
            
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
        
        
        
        
        timeLabel.text = "\(hundreds):\(tens):\(ones)"
    }
    
    
    
    func buttonAdjustments() {
        startButton.layer.cornerRadius = startButton.frame.height / 2
        
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowRadius = 3;
        startButton.layer.shadowOpacity = 0.5;
        startButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func setDistance() {
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            
            let val = value["TrialDistance"] as! Int
            
            self.distanceLabel.text = "Goal Distance: \(val)"
            
            self.dist = Double(val)
            
            
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    //TODO: Location!!!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(traveledDistance)
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            //            var speed: CLLocationSpeed = CLLocationSpeed()
            if startLocation == nil {
                startLocation = locations.first
            } else {
                if (traveledDistance >= dist) {
                    locationManager.stopUpdatingLocation()
                }
                let lastLocation = locations.last as! CLLocation
                if (startLocation.distance(from: lastLocation) > 4) {
                    let distance = startLocation.distance(from: lastLocation)
                    startLocation = lastLocation
                    traveledDistance += distance
                    updateSelfProgress()
                }
            }
        }
    }
    
    func updateSelfProgress() {
        //        distanceLabel.text = String(traveledDistance)
        UIView.animate(withDuration: 0.5) {
            self.progressBar.value = CGFloat(self.traveledDistance / self.dist) * 100
        }
    }
    
}
