//
//  AuthHandler.swift
//  ClassroomConnections
//
//  Created by Ricky Wang on 12/21/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit

class AuthHandler: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AuthManager.shared.authHandler = self
        AuthManager.shared.showApp()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(fork'sdflkjdf segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
