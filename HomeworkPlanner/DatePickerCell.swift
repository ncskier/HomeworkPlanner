//
//  DatePickerCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 10/5/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class DatePickerCell: StaticTableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
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
        datePicker.date = NSDate()
    }
}
