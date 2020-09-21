//
//  statsTableCell.swift
//  RunApp
//
//  Created by Michael Peng on 9/21/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit

class statsTableCell: UITableViewCell {

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var stamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
