//
//  customCellTableViewCell.swift
//  RunApp
//
//  Created by Ricky Wang on 8/12/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit

class customCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var cellLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
