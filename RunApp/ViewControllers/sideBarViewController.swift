//
//  sideBarViewController.swift
//  RunApp
//
//  Created by Ricky Wang on 8/12/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit

class sideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sideBarTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarTableView.delegate = self
        sideBarTableView.dataSource = self
        // Do any additional setup after loading the view.
        sideBarTableView.register(UINib(nibName: "customCellxib", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customCellTableViewCell
        
        let messageArray = ["Shop", "Terms of Service", "Gang shit", "Rhinoceros vs hippopotamus"]
        
        cell.cellLabel.text = messageArray[indexPath.row]
        
        return cell
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
