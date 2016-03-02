//
//  EnableAlertCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/7/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class EnableAlertCell: StaticTableViewCell {
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
