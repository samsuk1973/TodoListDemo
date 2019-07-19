//
//  TaskTableViewCell.swift
//  Task Demo
//
//  Created by Mac_mojave-2k19(2) 
//  Copyright © 2019 Mac_mojave-2k19(2). All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var standardLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var mainBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainBackView.layer.shadowColor = UIColor.gray.cgColor
        mainBackView.layer.shadowOpacity = 0.7
        mainBackView.layer.shadowOffset = CGSize.zero
        mainBackView.layer.shadowRadius = 4.5
        mainBackView.layer.cornerRadius = 8.0
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
