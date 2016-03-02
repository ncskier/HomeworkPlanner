//
//  AlertTimePickerCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 12/2/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class AlertTimePickerCell: StaticTableViewCell {
    
    @IBOutlet weak var alertDatePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func resetCell() {
        // Set date to current date
        alertDatePicker.date = NSDate()
    }

}
