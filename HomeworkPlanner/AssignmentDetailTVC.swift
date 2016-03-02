//
//  AssignmentDetailOutlineTableViewController.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/29/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData


class AssignmentDetailTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate, CourseSelectionTVCDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameCell: NameCell!
    @IBOutlet weak var notesCell: NotesCell!
    @IBOutlet weak var courseCell: StaticTableViewCell!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var completionSliderCell: CompletionSliderCell!
    @IBOutlet weak var dueDateTitleCell: StaticTableViewCell!
    @IBOutlet weak var dueDatePickerCell: DatePickerCell!
    @IBOutlet weak var enableAlertCell: EnableAlertCell!
    @IBOutlet weak var alertPickerCell: AlertPickerCell!
    @IBOutlet weak var alertTimeTitleCell: StaticTableViewCell!
    @IBOutlet weak var alertTimePickerCell: AlertTimePickerCell!
    @IBOutlet weak var deleteButtonCell: StaticTableViewCell!
    
    var assignmentManagedObject: NSManagedObject?
    var managedObjectContext: NSManagedObjectContext?
    var newAssignment: Bool = false
    var saveBarButton: UIBarButtonItem?
    var cancelBarButton: UIBarButtonItem?
    var doneBarButton: UIBarButtonItem?
    var courseManagedObject: NSManagedObject?
    var alertDate: NSDate?
    var alertPickerOptions = [
        "On due date",
        "1 day before",
        "2 days before",
        "3 days before",
        "4 days before",
        "5 days before",
        "6 days before",
        "7 days before"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Customize Table View
        tableView.keyboardDismissMode = .OnDrag
                
        
        // General Configuration of Cells
        // Section 0
        nameCell.indexPath = NSIndexPath(forRow: 0, inSection: 0)
        notesCell.indexPath = NSIndexPath(forRow: 1, inSection: 0)
        courseCell.indexPath = NSIndexPath(forRow: 2, inSection: 0)
        
        // Section 1
        completionSliderCell.indexPath = NSIndexPath(forRow: 0, inSection: 1)
        
        // Section 2
        dueDateTitleCell.indexPath = NSIndexPath(forRow: 0, inSection: 2)
        dueDatePickerCell.indexPath = NSIndexPath(forRow: 1, inSection: 2)
        enableAlertCell.indexPath = NSIndexPath(forRow: 2, inSection: 2)
        alertPickerCell.indexPath = NSIndexPath(forRow: 3, inSection: 2)
        alertTimeTitleCell.indexPath = NSIndexPath(forRow: 4, inSection: 2)
        alertTimePickerCell.indexPath = NSIndexPath(forRow: 5, inSection: 2)
        
        
        // Section 3
        deleteButtonCell.indexPath = NSIndexPath(forRow: 0, inSection: 3)
        
        // Set Notes Text View Delegate
        notesCell.notesTextView.delegate = self
        
        // Set Name Text Field Delegate
        nameCell.nameTextField.delegate = self
        
        // Setup the Alert Picker
        alertPickerCell.alertPicker.delegate = self
        alertPickerCell.alertPicker.dataSource = self
        
        // Hide picker cells
        dueDatePickerCell.hidden = true
        alertPickerCell.hidden = true
        alertTimePickerCell.hidden = true
        
        // Configure bar buttons
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveBarButtonPressed")
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelBarButtonPressed")
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneBarButtonPressed")
        
        // Register for keyboard dismissal notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        if (!newAssignment) {
            
            // Set Name
            nameCell.nameTextField.text = assignmentManagedObject!.valueForKey("name") as? String
            
            // Set Notes
            notesCell!.setNotesTextViewTextTo(newText: assignmentManagedObject!.valueForKey("notes") as! String)
            
            // Set Completion Slider
            completionSliderCell!.setCompletionSliderValueTo(assignmentManagedObject!.valueForKey("percentComplete") as! Int)
            completionSliderCell!.checkboxButton.selected = assignmentManagedObject!.valueForKey("complete") as! Bool
            
            // Set Due Date
            dueDatePickerCell.datePicker.date = assignmentManagedObject!.valueForKey("dueDate") as! NSDate
            
            // Set Alert Date
            if let alertNotification = assignmentManagedObject?.valueForKey("notification") as? UILocalNotification {
                
                enableAlertCell.enableSwitch.on = true
                
                // Set Alert Pickers
                let normalizedAlertDate = DateFormatHelper.normalizeDueDate(alertNotification.fireDate!)
                let normalizedDueDate = DateFormatHelper.normalizeDueDate(assignmentManagedObject!.valueForKey("dueDate") as! NSDate)
                let timeInterval = normalizedDueDate.timeIntervalSinceDate(normalizedAlertDate)
                let numDays = Int(timeInterval/86400.0)      // 86400 seconds in a day
                if (numDays > 0 && numDays < alertPickerOptions.count) {
                    alertPickerCell.alertPicker.selectRow(numDays, inComponent: 0, animated: false)
                } else {
                    print("ERROR: alert date")
                }
                
                alertTimePickerCell.alertDatePicker.date = alertNotification.fireDate!
                
            } else {
                
                enableAlertCell.enableSwitch.on = false
                hideAlertCells()
            }
            
            // Set Course Cell
            if let course = assignmentManagedObject?.valueForKey("course") as? NSManagedObject {
                configureCourseCell(withManagedObject: course)
//                courseCell.configureCell(fromManagedObject: course)
                updateCompletionSliderColor()
                
                // Setup Checkbox Color
                completionSliderCell.checkboxButton.color = course.valueForKey("color") as? UIColor
                completionSliderCell.checkboxButton.setNeedsDisplay()   // Redraw
            } else {
                courseCellSetNoCourseText()
//                courseCell.setNoCourseText()
                
                // Setup Checkbox Color
                completionSliderCell.checkboxButton.color = nil
            }
            
            // Hide if complete
            if (assignmentManagedObject!.valueForKey("complete") as! Bool) {
                hideCellsUnderComplete()
            }
            
        } else {    // New Assignment
            
            // Select name field
            nameCell.nameTextField.becomeFirstResponder()
            
            // Add cancel and save bar buttons
            navigationItem.rightBarButtonItem = saveBarButton
            navigationItem.leftBarButtonItem = cancelBarButton
            
            // Disable alerts and hide
            enableAlertCell.enableSwitch.on = false
            hideAlertCells()
            
            // Hide Delete Cell
            deleteButtonCell.hidden = true
        }
        
        // Refresh Titles
        refreshDueDateTitle()
        refreshEnableAlertTitle()
        refreshAlertTimeTitle()
    }
    
    func hideAlertCells() {
        alertPickerCell.hidden = true
        alertTimeTitleCell.hidden = true
        alertTimePickerCell.hidden = true
    }
    
    func hideCellsUnderComplete() {
        dueDateTitleCell.hidden = true
        dueDatePickerCell.hidden = true
        enableAlertCell.hidden = true
        alertPickerCell.hidden = true
        alertTimeTitleCell.hidden = true
        alertTimePickerCell.hidden = true
    }
    
    func showCellsUnderComplete() {
        dueDateTitleCell.hidden = false
        enableAlertCell.hidden = false
        
        if (enableAlertCell.enableSwitch.on) {
            alertTimeTitleCell.hidden = false
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
    
    
    // MARK: - Interface with previous VC's
    
    func loadAssignment(fromData data: NSManagedObject, withManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        
        newAssignment = false
        title = data.valueForKey("name") as? String
        
        self.managedObjectContext = managedObjectContext
        
        assignmentManagedObject = data
    }
    
    
    func setupForNewAssignment(withManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        
        newAssignment = true
        
        title = "New Assignment"
        
        self.managedObjectContext = managedObjectContext
    }
    
    
    // MARK: - Course Selection Delegate
    func setSelectedCourse(toCourse courseManagedObject: NSManagedObject) {
        
        configureCourseCell(withManagedObject: courseManagedObject)
//        courseCell.configureCell(fromManagedObject: courseManagedObject)
        
        // Update Completion Slider Color
        updateCompletionSliderColor()
        
        // Update Checkbox Color
        completionSliderCell.checkboxButton.color = courseManagedObject.valueForKey("color") as? UIColor
        completionSliderCell.checkboxButton.setNeedsDisplay()   // Redraw
        
        if (!newAssignment) {
            
            assignmentManagedObject!.setValue(courseManagedObject, forKey: "course")
            saveManagedObjectContext()
        }
    }
    
    func configureCourseCell(withManagedObject managedObject: NSManagedObject) {
        
        courseManagedObject = managedObject
        
        courseNameLabel.text = managedObject.valueForKey("name") as? String
        courseNameLabel.textColor = managedObject.valueForKey("color") as? UIColor
    }
    
    func courseCellSetNoCourseText() {
        
        courseNameLabel.text = "No Course"
        courseNameLabel.textColor = UIColor.lightGrayColor()
    }
    
    
    // MARK: - Bar Button Actions
    
    func saveBarButtonPressed() {
        
        // Only called for NEW ASSIGNMENT
        // Save the new assignment...
        
        // Create the entity
        print("managed object context: \(managedObjectContext)")
        let assignmentDataEntity = NSEntityDescription.entityForName("AssignmentData", inManagedObjectContext: managedObjectContext!)
        
        // Initialize Managed Object
        let newAssignment = NSManagedObject(entity: assignmentDataEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        
        // Populate Managed Object
        let name = nameCell!.nameTextField.text
        let notes = notesCell!.notesTextView.text
        let percent = Int(completionSliderCell!.completionSlider.value)
        let dueDate = DateFormatHelper.normalizeDueDate(dueDatePickerCell!.datePicker.date)
        let complete = completionSliderCell!.checkboxButton.selected
        var notification: UILocalNotification? = nil
        if (enableAlertCell.enableSwitch.on) {
            notification = notificationForAssignment()
            
            // Schedule Notification
            UIApplication.sharedApplication().scheduleLocalNotification(notification!)
        }
        
        newAssignment.setValue(name!, forKey: "name")
        newAssignment.setValue(notes, forKey: "notes")
        newAssignment.setValue(percent, forKey: "percentComplete")
        newAssignment.setValue(dueDate, forKey: "dueDate")
        newAssignment.setValue(complete, forKey: "complete")
        newAssignment.setValue(notification, forKey: "notification")
        newAssignment.setValue(courseManagedObject, forKey: "course")
        
        // Save Managed Object
        saveManagedObjectContext()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelBarButtonPressed() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneBarButtonPressed() {
        
        // Dismiss Keyboard
        view.endEditing(false)
        
        // Change Right Bar Button
        if (newAssignment) {
            navigationItem.rightBarButtonItem = saveBarButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
        if (navigationItem.rightBarButtonItem == doneBarButton) {
            if (newAssignment) {
                navigationItem.rightBarButtonItem = saveBarButton
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    
    // MARK: - Delete Button
    
    func deleteAssignment() {
        
        print("deleteAssignment")
        
        if (!newAssignment) {
            // Cancel notification
            let alertNotification = assignmentManagedObject?.valueForKey("notification") as? UILocalNotification
            if (alertNotification != nil) {
                UIApplication.sharedApplication().cancelLocalNotification(alertNotification!)
            }

            // Delete From Managed Context
            managedObjectContext!.deleteObject(assignmentManagedObject!)
            saveManagedObjectContext()
            
            // Dismiss View
            let navController = navigationController
            navController?.popViewControllerAnimated(true)
            
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    // MARK: - Name Text Field Cell Delegate
    
    @IBAction func nameTextFieldValueChanged(sender: UITextField) {
        let newValue = sender.text
        title = newValue
        
        if (!newAssignment) {
            
            assignmentManagedObject!.setValue(newValue, forKey: "name")
            
            saveManagedObjectContext()
        }
    }
    
    @IBAction func nameTextFieldEditingDidBegin(sender: UITextField) {
        
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
                
        // Select Notes Cell
        notesCell.notesTextView.becomeFirstResponder()
        
        return false
    }
    
    
    // MARK: - Notes Text View Cell Delegate
    
    func textViewDidChange(textView: UITextView) {
        let newValue = textView.text
        
        notesCell.refreshPlaceholderLabel()
        
        if (!newAssignment) {
            assignmentManagedObject!.setValue(newValue, forKey: "notes")
            
            saveManagedObjectContext()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        navigationItem.rightBarButtonItem = doneBarButton
    }

    
    // MARK: - Completion Slider Cell Delegate
    
    @IBAction func completionSliderValueChanged(sender: UISlider) {
        let newValue = sender.value
        
        completionSliderCell.updatePercentLabel()
        
        if (!newAssignment) {
            assignmentManagedObject!.setValue(Int(newValue), forKey: "percentComplete")
            
            saveManagedObjectContext()
        }
    }
    
    @IBAction func toggleCheckboxButton(sender: CheckboxButton) {
        
        if (!sender.selected) {
            // Hide all fields under checkbox
            tableView.beginUpdates()
            hideCellsUnderComplete()
            tableView.endUpdates()
        } else {
            // Show all fields under checkbox
            tableView.beginUpdates()
            showCellsUnderComplete()
            tableView.endUpdates()
        }
        
        if (!newAssignment) {
            let complete = assignmentManagedObject!.valueForKey("complete") as! Bool
            
            assignmentManagedObject!.setValue(!complete, forKey: "complete")
            
            saveManagedObjectContext()
            
            completionSliderCell.checkboxButton.selected = !complete
            
            // Manage Notifications
            let alertNotification = assignmentManagedObject?.valueForKey("notification") as? UILocalNotification
            if (!complete) {
                // Cancel notification
                if (alertNotification != nil) {
                    UIApplication.sharedApplication().cancelLocalNotification(alertNotification!)
                }
            } else {
                // Re-Apply notification
                if (alertNotification != nil) {
                    UIApplication.sharedApplication().scheduleLocalNotification(alertNotification!)
                }
            }
        }
        else {
            completionSliderCell.checkboxButton.selected = !completionSliderCell.checkboxButton.selected
        }
    }
    
    func updateCompletionSliderColor() {
        if (courseManagedObject != nil) {
            let color = courseManagedObject!.valueForKey("color") as? UIColor
            completionSliderCell.completionSlider.minimumTrackTintColor = color
        } else {
            completionSliderCell.completionSlider.minimumTrackTintColor = completionSliderCell.completionSlider.tintColor
        }
    }
    
    // MARK: - Due Date Title Cell
    
    func refreshDueDateTitle() {
        
        let formatter = DateFormatHelper.dateFormatterWithDateFormat(DateFormatHelper.formatLocal_EdMMMyyyy!)
        dueDateTitleCell.detailTextLabel?.text? = formatter.stringFromDate(dueDatePickerCell.datePicker.date)
    }
    
    // MARK: - Due Date Picker Cell Delegate
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        
        let newDate = sender.date
        
        // Update Alert Title cells
        refreshAlertTimeTitle()
        updateAlertDateData()
        
        // Update date title cell
        let formatter = DateFormatHelper.dateFormatterWithDateFormat(DateFormatHelper.formatLocal_EdMMMyyyy!)
        dueDateTitleCell.detailTextLabel?.text? = formatter.stringFromDate(dueDatePickerCell.datePicker.date)
        
        if (!newAssignment) {
            assignmentManagedObject!.setValue(DateFormatHelper.normalizeDueDate(newDate), forKey: "dueDate")
            
            saveManagedObjectContext()
        }
    }
    
    
    
    // MARK: - Enable Alert Cell
    
    @IBAction func enableSwitchValueChanged(sender: UISwitch) {
        
        refreshEnableAlertTitle()
        
        if (sender.on) {
            // Show alert title
            tableView.beginUpdates()
            alertTimeTitleCell.hidden = false
            tableView.endUpdates()
        } else {
            // Hide alert title
            tableView.beginUpdates()
            hideAlertCells()
            tableView.endUpdates()
        }
        
        if (!newAssignment) {
            if let alertNotification = assignmentManagedObject?.valueForKey("notification") as? UILocalNotification {
                
                // Cancel notification
                UIApplication.sharedApplication().cancelLocalNotification(alertNotification)
            }
            
            // Remove Notification
            assignmentManagedObject!.setValue(nil, forKey: "notification")
            
            if (sender.on) {
                // Create and Save Notification
                updateAlertDateData()
                
                // Jump Screen to Alert Cell
                tableView.scrollToRowAtIndexPath(alertTimeTitleCell.indexPath!, atScrollPosition: .Middle, animated: true)
            }
            
            saveManagedObjectContext()
        }
        
    }
    
    func refreshEnableAlertTitle() {
        
        if (enableAlertCell.enableSwitch.on) {
            enableAlertCell.detailTextLabel?.text? = alertPickerOptions[alertPickerCell.alertPicker.selectedRowInComponent(0)]
        } else {
            enableAlertCell.detailTextLabel?.text? = "No alert"
        }
    }
    
    
    // MARK: - Alert Picker View Data Source
        
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alertPickerOptions.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // MARK: - Alert Picker View Delegate Methods
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return alertPickerOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        refreshEnableAlertTitle()
        refreshAlertTimeTitle()
        
        updateAlertDateData()
    }
    
    
    // MARK: - Alert Time Title Cell
    func refreshAlertTimeTitle() {
        
        let formatter = DateFormatHelper.dateFormatterWithDateFormat(DateFormatHelper.formatLocal_EdMMMyyyyhhmma!)
        alertTimeTitleCell.detailTextLabel?.text? = formatter.stringFromDate(getAlertDate())
    }
    
    // MARK: - Alert Time Picker Cell Delegate
    
    @IBAction func alertTimePickerValueChanged(sender: UIDatePicker) {
        // Update date title cell
        refreshAlertTimeTitle()
        
        // Update Data
        updateAlertDateData()
    }
    
    func getAlertDate() -> NSDate {
        
        let selectedRow = alertPickerCell.alertPicker.selectedRowInComponent(0)
        
        let dueDate = dueDatePickerCell.datePicker.date
        
        let alertDate = dueDate.dateByAddingTimeInterval(86400 * -1.0 * Double(selectedRow))
        
        let normalizedDate = DateFormatHelper.normalizeDueDate(alertDate)
        
        // Get time interval of alert time
        let normalizedTimeDate = DateFormatHelper.normalizeDueDate(alertTimePickerCell.alertDatePicker.date)
        let alertTimeInterval = alertTimePickerCell.alertDatePicker.date.timeIntervalSinceDate(normalizedTimeDate)
        let normalizedAlertTimeInterval = DateFormatHelper.normalizeTimeIntervalToMinutes(alertTimeInterval)
        
        let finalAlertDate = normalizedDate.dateByAddingTimeInterval(normalizedAlertTimeInterval)
        
        print("")
        print("normalizedTimeDate: \(normalizedTimeDate)")
        print("normalizedAlertDate: \(normalizedDate)")
        print("alertDate: \(alertDate)")
        print("alertTime: \(alertTimePickerCell.alertDatePicker.date)")
        print("finalAlertDate: \(finalAlertDate)")
        
        return finalAlertDate
    }
    
    func updateAlertDateData() {
        
        if (!newAssignment) {
            // Cancel previous notification
            if let alertNotification = assignmentManagedObject?.valueForKey("notification") as? UILocalNotification {
                
                // Cancel old notification
                UIApplication.sharedApplication().cancelLocalNotification(alertNotification)
            }
            
            let notification = notificationForAssignment()
            
            // Save new notification
            assignmentManagedObject!.setValue(notification, forKey: "notification")
            saveManagedObjectContext()
            
            // Schedule Local Notification
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func notificationForAssignment() -> UILocalNotification {
        
        let alertDate = getAlertDate()
        
        let name = nameCell.nameTextField.text!
        let dateFormatter = DateFormatHelper.dateFormatterWithDateFormat(DateFormatHelper.formatLocal_EdMMMyyyy!)
        var dueDateString = dateFormatter.stringFromDate(dueDatePickerCell.datePicker.date)
        dueDateString = DateFormatHelper.addTagsToFormattedDate(dueDateString, fromDateFormatter: dateFormatter)
        let notification = UILocalNotification()
        var text = "\"\(name)\""
        if (courseManagedObject != nil) {
            let course = courseManagedObject!.valueForKey("name") as! String
            text += " for \"\(course)\""
        }
        text += " due \(dueDateString)"
        notification.alertBody = text
        notification.fireDate = alertDate
        notification.soundName = UILocalNotificationDefaultSoundName
        
        return notification
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if (selectedCell != nil) {
            
            if (selectedCell == dueDateTitleCell) {
                
                tableView.beginUpdates()
                dueDatePickerCell.hidden = !dueDatePickerCell.hidden

                // Hide alertPickerCell or alertTimePickerCell if not hidden
                if (!alertPickerCell.hidden) {
                    alertPickerCell.hidden = true
                }
                if (!alertTimePickerCell.hidden) {
                    alertTimePickerCell.hidden = true
                }
                tableView.endUpdates()
                
                // Scroll to the picker cell
                tableView.scrollToRowAtIndexPath(dueDatePickerCell.indexPath!, atScrollPosition: .Middle, animated: true)
                
                // Deselect the cell
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            else if (selectedCell == enableAlertCell) {
                
                tableView.beginUpdates()
                alertPickerCell.hidden = !alertPickerCell.hidden
                
                // Hide dueDatePickerCell or alertTimePickerCell if not hidden
                if (!dueDatePickerCell.hidden) {
                    dueDatePickerCell.hidden = true
                }
                if (!alertTimePickerCell.hidden) {
                    alertTimePickerCell.hidden = true
                }
                
                // Enable Alerts
                if (!enableAlertCell.enableSwitch.on) {
                    enableAlertCell.enableSwitch.on = true
                    alertTimeTitleCell.hidden = false
                }
                tableView.endUpdates()
                
                // Update Titles
                refreshEnableAlertTitle()
                refreshAlertTimeTitle()
                
                // Scroll to the picker cell
                tableView.scrollToRowAtIndexPath(alertPickerCell.indexPath!, atScrollPosition: .Middle, animated: true)
                
                // Deselect the cell
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            else if (selectedCell == alertTimeTitleCell) {
                
                // Toggle Time Picker Cell
                tableView.beginUpdates()
                alertTimePickerCell.hidden = !alertTimePickerCell.hidden
                
                // Hide dueDatePickerCell or alertPickerCell if not hidden
                if (!dueDatePickerCell.hidden) {
                    dueDatePickerCell.hidden = true
                }
                if (!alertPickerCell.hidden) {
                    alertPickerCell.hidden = true
                }
                tableView.endUpdates()
                
                // Scroll to time picker cell
                tableView.scrollToRowAtIndexPath(alertTimePickerCell.indexPath!, atScrollPosition: .Bottom, animated: true)
                
                // Deselect the cell
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            else if (selectedCell == deleteButtonCell) {
                // Present alert
                let deleteAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                let deleteAction = UIAlertAction(
                    title: "Delete Assignment",
                    style: .Destructive,
                    handler: {(action) in
                    self.deleteAssignment()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) in
                    self.tableView.deselectRowAtIndexPath(self.deleteButtonCell.indexPath!, animated: true)
                })
                
                deleteAlertController.addAction(deleteAction)
                deleteAlertController.addAction(cancelAction)
                
                presentViewController(deleteAlertController, animated: true, completion: nil)
            }
            
            else if (selectedCell == courseCell) {
                performSegueWithIdentifier("courseSelectionSegue", sender: self)
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (indexPath) {
            
        case nameCell.indexPath!:
            return nameCell.frame.height
            
        case notesCell.indexPath!:
            return notesCell.frame.height
            
        case completionSliderCell.indexPath!:
            return completionSliderCell.frame.height
            
        case dueDateTitleCell.indexPath!:
            if (dueDateTitleCell.hidden) {
                return 0
            }
            else {
                return 44
            }
            
        case dueDatePickerCell.indexPath!:
            if (dueDatePickerCell.hidden) {
                return 0
            }
            else {
                return 216
            }
            
        case enableAlertCell.indexPath!:
            if (enableAlertCell.hidden) {
                return 0
            } else {
                return 44
            }
            
        case alertPickerCell.indexPath!:
            if (alertPickerCell.hidden) {
                return 0
            }
            else {
                return 216
            }
            
        case alertTimeTitleCell.indexPath!:
            if (alertTimeTitleCell.hidden) {
                return 0
            }
            else {
                return 44
            }
            
        case alertTimePickerCell.indexPath!:
            if (alertTimePickerCell.hidden) {
                return 0
            } else {
                return 216
            }
            
        case deleteButtonCell.indexPath!:
            if (deleteButtonCell.hidden) {
                return 0
            }
            else {
                return 44
            }

        default:
            return 44
        }
    }
    
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        if (indexPath.section == 0) {
            
            switch (indexPath.row) {
            case 0:
                return nameCell!
                
            case 1:
                return notesCell!
                
            default:
                print("Error with cell for row at index path section: \(indexPath.section), row: \(indexPath.row)")
                return tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")!
            }
        }
        else if (indexPath.section == 1) {
            
            switch (indexPath.row) {
            case 0:
                return percentCompleteCell!
            default:
                print("Error with cell for row at index path section: \(indexPath.section), row: \(indexPath.row)")
                return tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")!
            }
        }
        else if (indexPath.section == 2) {
            
            switch (indexPath.row) {
            case 0:
                return dueDatePickerCell!
            default:
                print("Error with cell for row at index path section: \(indexPath.section), row: \(indexPath.row)")
                return tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")!
            }
        }
        
        else {
            
            print("Error with cell for row at index path SECTION")
            return tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")!
        }
        
        // Configure the cell...
        
//        return cell
    }
    */
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        let newVC = segue.destinationViewController
        
        if (segue.identifier == "courseSelectionSegue") {
            
            let courseSelectionVC = newVC as! CourseSelectionTVC
            courseSelectionVC.configure(withSelectedCourse: courseManagedObject, andDelegate: self)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
