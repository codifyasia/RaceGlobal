//
//  StatisticsViewController.swift
//  RunApp
//
//  Created by Michael Peng on 10/9/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import Firebase
import UIKit

class StatisticsViewController: UIViewController {
    
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var racesCompleted: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var mile: UILabel!
    @IBOutlet weak var bestEightHundred: UILabel!
    @IBOutlet weak var BestFiveKilometer: UILabel!
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
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
    
    func retrieveData(){
        
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
