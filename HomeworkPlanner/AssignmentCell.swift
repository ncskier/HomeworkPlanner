//
//  AssignmentCell.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/28/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData


protocol AssignmentCellDelegate {
    
    func changePercentComplete(toNewValue newValue: Int, forCellAtIndexPath indexPath: NSIndexPath)
    func assignmentCell(deselectAssignmentCellAtIndexPath indexPath: NSIndexPath)
}


class AssignmentCell: UITableViewCell {
    
    // Class variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var completionSlider: UISlider!
    @IBOutlet weak var tintView: UIView!
    
    var managedObjectContext: NSManagedObjectContext?
    var assignmentManagedObject: NSManagedObject?
    var indexPath: NSIndexPath?
    var delegate: AssignmentCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set up gesture recognizer
//        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "userDidDoubleTap:")
//        doubleTapGestureRecognizer.numberOfTapsRequired = 2
//        doubleTapGestureRecognizer.delaysTouchesBegan = true
//        addGestureRecognizer(doubleTapGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "userDidSwipeRight:")
        swipeRightGestureRecognizer.direction = .Right
        addGestureRecognizer(swipeRightGestureRecognizer)
        
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "userDidLongPress:")
//        addGestureRecognizer(longPressGestureRecognizer)
        
        // Set up tint view
        tintView.frame = frame
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    
    func configureCell(fromData loadData: NSManagedObject, withDelegate delegate: AssignmentCellDelegate, andManagedObjectContext managedObjectContext: NSManagedObjectContext, indexPath: NSIndexPath) {
        
        // Configure the cell
        nameLabel.text = loadData.valueForKey("name") as? String
        let value = loadData.valueForKey("percentComplete") as! Int
        completionSlider.value = Float(value)
        checkboxButton.selected = loadData.valueForKey("complete") as! Bool
        let prioritize = loadData.valueForKey("prioritize") as! Bool
        
        self.delegate = delegate
        self.managedObjectContext = managedObjectContext
        self.assignmentManagedObject = loadData
        self.indexPath = indexPath
        
        setPriorityTo(priority: prioritize)
        
        if let course = loadData.valueForKey("course") {
            let color = course.valueForKey("color") as? UIColor
            tintView.backgroundColor = color
        }
    }
    
    
    func userDidSwipeRight(swipeRightGestureRecognizer: UISwipeGestureRecognizer) {
        
        // Toggle highlighted option
        let prioritize = assignmentManagedObject!.valueForKey("prioritize") as! Bool
        assignmentManagedObject!.setValue(!prioritize, forKey: "prioritize")
        
        saveManagedObjectContext()
        
        setPriorityTo(priority: !prioritize)
    }
    
    
//    func userDidDoubleTap(doubleTabGestureRecognizer: UITapGestureRecognizer) {
//        
//        // Toggle highlighted option
//        let prioritize = assignmentManagedObject!.valueForKey("prioritize") as! Bool
//        assignmentManagedObject!.setValue(!prioritize, forKey: "prioritize")
//        
//        saveManagedObjectContext()
//        
//        setPriorityTo(priority: !prioritize)
//        
//        // Deselect Cell
////        delegate!.assignmentCell(deselectAssignmentCell: self)
////        selected = false
//    }
    
    
//    func userDidLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
//        
//        print("Long Press")
//        
//        // Toggle highlighted option
//        let prioritize = assignmentManagedObject!.valueForKey("prioritize") as! Bool
//        assignmentManagedObject!.setValue(!prioritize, forKey: "prioritize")
//        
//        saveManagedObjectContext()
//        
//        setPriorityTo(priority: prioritize)
//        
//        // Deselect Cell
//        delegate!.assignmentCell(deselectAssignmentCell: self)
//        selected = false
//    }
    
    
    func setPriorityTo(priority priority: Bool) {
        
        if (priority) {
            
            // Load priority color
            let standardDefaults = NSUserDefaults.standardUserDefaults()
            
            let redValue = standardDefaults.valueForKey("priorityRedColor") as! CGFloat
            let greenValue = standardDefaults.valueForKey("priorityGreenColor") as! CGFloat
            let blueValue = standardDefaults.valueForKey("priorityBlueColor") as! CGFloat
            
            let priorityColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 0.2)
            
            tintView.backgroundColor = priorityColor
        }
        else {
            
            tintView.backgroundColor = UIColor.clearColor()
        }
    }
    
    
    // MARK: - Core Data Methods
    
    func saveManagedObjectContext() {
        
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Triggered IBActions
    
    @IBAction func completionSliderValueChanged(sender: UISlider) {
        
        let newValue: Int = Int(sender.value)
        delegate?.changePercentComplete(toNewValue: newValue, forCellAtIndexPath: indexPath!)
    }
    
    @IBAction func checkboxButtonPressed(sender: UIButton) {
        
        let complete = assignmentManagedObject!.valueForKey("complete") as! Bool
        
        assignmentManagedObject!.setValue(!complete, forKey: "complete")
        
        saveManagedObjectContext()
        
        checkboxButton.selected = !complete
        
        // Manage Notifications
        let alertNotification = assignmentManagedObject?.valueForKey("notification") as? UILocalNotification
        if (!complete) {
            // Cancel Notification
            if (alertNotification != nil) {
                UIApplication.sharedApplication().cancelLocalNotification(alertNotification!)
            }
        } else {
            // Restore Notification
            if (alertNotification != nil) {
                UIApplication.sharedApplication().scheduleLocalNotification(alertNotification!)
            }
        }
    }
    

}
