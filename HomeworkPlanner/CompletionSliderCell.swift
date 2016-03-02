//
//  CompletionSliderCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/29/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class CompletionSliderCell: StaticTableViewCell {
    
    @IBOutlet weak var completionSlider: UISlider!
    @IBOutlet weak var checkboxButton: CheckboxButton!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setCompletionSliderValueTo(0)
    }
    
    func resetCompletionSliderCell() {
        completionSlider.value = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updatePercentLabel() {
        
        let value = Int(completionSlider.value)
        percentLabel.text = "\(value)%"
    }
    
    func setCompletionSliderValueTo(value: Int) {
        
        completionSlider.value = Float(value)
        
        let value = Int(completionSlider.value)
        percentLabel.text = "\(value)%"
    }
}
