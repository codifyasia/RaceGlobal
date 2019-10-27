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
    
    @IBOutlet weak var SadFace: AnimationView!
    @IBOutlet var loseLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        // Do any additional setup after loading the view.
    }
    
    
    func startAnimation() {
        SadFace.animation = Animation.named("Sad")
        SadFace.loopMode = .loop
        SadFace.play()
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
