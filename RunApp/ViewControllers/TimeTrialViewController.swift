//
//  TimeTrialViewController.swift
//  RunApp
//
//  Created by Michael Peng on 11/2/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class TimeTrialViewController: UIViewController {
    
    //Firebase reference
    
    
    //custom text
    var customNum : Int = 0
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var racesCompleted: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var mile: UILabel!
    @IBOutlet weak var BestFiveKilometer: UILabel!
    @IBOutlet weak var trialButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    var statsList: [statClass] = [statClass]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        
                trialButton.layer.cornerRadius = trialButton.frame.height / 2
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowRadius = 3;
        tableView.layer.shadowOpacity = 0.5;
        trialButton.layer.shadowColor = UIColor.black.cgColor
        trialButton.layer.shadowRadius = 3;
        trialButton.layer.shadowOpacity = 0.5;
        trialButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            
            
            self.distance.text = "Total Distance Ran: \(value["TotalDistance"] as! Int)"
            self.racesCompleted.text = "Races Completed: \(value["CompletedRaces"] as! Int)"
            self.wins.text = "Races Won: \(value["Wins"] as! Int)"
            
            
            
            
            print("bin \(value["Wins"] as! Int)")
            
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        
        
    }
    @IBAction func startPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Distance", message: "Choose the distance you would like to have a time trial for", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "800 Meters", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 800])
            self.performSegue(withIdentifier: "toTrial", sender: self)
        }
        
        let action2 = UIAlertAction(title: "1600 Meters", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 1600])
            self.performSegue(withIdentifier: "toTrial", sender: self)
            
        }
        let action3 = UIAlertAction(title: "3200 Meters", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 3200])
            self.performSegue(withIdentifier: "toTrial", sender: self)
            
        }
        let action4 = UIAlertAction(title: "5 Kilometers", style: .default) { (action) in
            self.ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).updateChildValues(["TrialDistance" : 5000])
            self.performSegue(withIdentifier: "toTrial", sender: self)
        }

        
        
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
//        alert.addAction(action5)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    func retrieveData(){
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).child("Previous").observeSingleEvent(of: .value, with: { (snapshot) in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = users.value as? NSDictionary else {
                    return
                }
                let d = value["dist"] as! Double
//                let w = value["won"] as! Bool
                let date = value["date"] as! String
                
                self.statsList.append(statClass(dist: d, time: 10, stamp: 10))
                
                
//                self.playerList.append(playerCell(user: name, score: score))
                
                
                
            }
            
//            self.playerList = self.playerList.sorted() { $0.score > $1.score }
            self.tableView.reloadData()
        }) { (error) in
            print("error:(error.localizedDescription)")
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

extension TimeTrialViewController: UITableViewDelegate{
    
}

extension TimeTrialViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bell", for: indexPath) as! statsTableCell
        
        cell.distance.text = String(statsList[indexPath.row].dist)
//        cell.time.text = String(statsList[indexPath.row].time)
//        cell.stamp.text = String(statsList[indexPath.row].stamp)
        return cell
    }
    
    
}
