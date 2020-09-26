//
//  AuthManager.swift
//  ClassroomConnections
//
//  Created by Ricky Wang on 12/21/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import Firebase
import UIKit

class AuthManager {
    static let shared = AuthManager()
    var ref : DatabaseReference!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var authHandler: AuthHandler!
    
    private init() {
        ref = Database.database().reference()
    }
    
    func showApp() {
        var viewController: UIViewController

        if (Auth.auth().currentUser == nil) {
            print("auth is nil")
            viewController = storyboard.instantiateViewController(withIdentifier: "Register")
            authHandler.present(viewController, animated: false, completion: nil)
        } else {
            let viewController: UIViewController = self.storyboard.instantiateViewController(withIdentifier: "MainStoryboard")
            self.authHandler.present(viewController, animated: false, completion: nil)
        }
    }
    
    
}


