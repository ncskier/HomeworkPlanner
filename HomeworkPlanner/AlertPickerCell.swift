//
//  AlertPickerCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 12/7/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class AlertPickerCell: StaticTableViewCell {
    
    @IBOutlet weak var alertPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
