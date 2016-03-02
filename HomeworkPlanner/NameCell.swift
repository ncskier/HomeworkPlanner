//
//  TextFieldCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/29/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class NameCell: StaticTableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func reset() {
        nameTextField.text = ""
    }
}
