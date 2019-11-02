//
//  WinScreen.swift
//  RunApp
//
//  Created by Gavin on 10/21/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class LoseScreen: UIViewController {
    
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var msgsPressed: UIButton!
    @IBOutlet var runningFlash: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        // Do any additional setup after loading the view.
    }
    
    
    func startAnimation() {
        runningFlash.animation = Animation.named("runningFlash")
        runningFlash.loopMode = .loop
        runningFlash.play()
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
