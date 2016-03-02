//
//  TextViewCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/29/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class NotesCell: StaticTableViewCell {

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reset() {
        notesTextView.text = ""
    }
    
    func refreshPlaceholderLabel() {
        
        if (notesTextView.text == "") {
            
            placeholderLabel.hidden = false
        }
        else {
            
            placeholderLabel.hidden = true
        }
    }
    
    func setNotesTextViewTextTo(newText text: String) {
        
        notesTextView.text = text
        
        // Show or hide placeholderLabel
        refreshPlaceholderLabel()
    }
}
