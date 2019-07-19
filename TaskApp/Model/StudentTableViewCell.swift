//
//  StudentTableViewCell.swift
//  Student Demo
//
//  Created by Mac_mojave-2k19(2) 
//  Copyright © 2019 Mac_mojave-2k19(2). All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var standardLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
