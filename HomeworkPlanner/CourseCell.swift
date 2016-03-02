//
//  CourseCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/12/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

class CourseCell: StaticTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var courseManagedObject: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(fromManagedObject courseManagedObject: NSManagedObject) {
        
        nameLabel.text = courseManagedObject.valueForKey("name") as? String
        nameLabel.textColor = courseManagedObject.valueForKey("color") as? UIColor
        self.courseManagedObject = courseManagedObject
    }
    
    func setNoCourseText() {
        
        // Set nameLabel to ligth grey text "No Course"
        
    }
    
    
    
}
