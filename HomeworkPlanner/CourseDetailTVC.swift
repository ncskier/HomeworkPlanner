//
//  CourseDetailTVC.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/12/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

class CourseDetailTVC: UITableViewController, ColorSelectorCellDelegate {

    @IBOutlet weak var nameCell: NameCell!
    @IBOutlet weak var deleteButtonCell: StaticTableViewCell!
    @IBOutlet weak var colorSelectorCell: ColorSelectorCell!
    
    var courseManagedObject: NSManagedObject?
    var managedObjectContext: NSManagedObjectContext?
    var newCourse: Bool = false
    var saveBarButton: UIBarButtonItem?
    var cancelBarButton: UIBarButtonItem?
    var doneBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Customize Table View
        tableView.keyboardDismissMode = .OnDrag
        
        // Set Index Paths
        colorSelectorCell.indexPath = NSIndexPath(forRow: 0, inSection: 1)
        deleteButtonCell.indexPath = NSIndexPath(forRow: 0, inSection: 2)
        
        // Configure bar buttons
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveBarButtonPressed")
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelBarButtonPressed")
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneBarButtonPressed")
        
        // Register for keyboard dismissal notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        // Set Color Selector Cell Delegate
        colorSelectorCell.delegate = self
        
        if (!newCourse) {
            
            // Set tint color
            let color = courseManagedObject!.valueForKey("color") as? UIColor
            
            // Configure Color Selector Cell
            colorSelectorCell.configureCell(withWidth: view.frame.width, andSelectedColor: color)
            
            // Set name
            let name = courseManagedObject!.valueForKey("name") as? String
            nameCell.nameTextField.text = name
        }
        else {  // New Course
            
            // Configure Color Selector Cell
            colorSelectorCell.configureCell(withWidth: view.frame.width, andSelectedColor: nil)
            
            // Select name text field
            nameCell.nameTextField.becomeFirstResponder()
            
            // Add bar buttons
            navigationItem.rightBarButtonItem = saveBarButton
            navigationItem.leftBarButtonItem = cancelBarButton
            
            // Hide delete cell
            deleteButtonCell.hidden = true
        }
        
    }
    
    
    // MARK: - Bar Button Actions
    
    func saveBarButtonPressed() {
        
        // Create the entity
        let courseDataEntity = NSEntityDescription.entityForName("CourseData", inManagedObjectContext: managedObjectContext!)
        
        // Initialize Managed Object
        let newCourse = NSManagedObject(entity: courseDataEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        
        // Populate Managed Object
        let color = colorSelectorCell.selectedButton?.fillColor
        let name = nameCell.nameTextField.text
        
        newCourse.setValue(color, forKey: "color")
        newCourse.setValue(name, forKey: "name")
        
        // Save Managed Object
        saveManagedObjectContext()
        
        // Dismiss VC
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelBarButtonPressed() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneBarButtonPressed() {
        
        // Dismiss Keyboard
        view.endEditing(false)
        
        // Change Right Bar Button
        if (newCourse) {
            navigationItem.rightBarButtonItem = saveBarButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
        if (navigationItem.rightBarButtonItem == doneBarButton) {
            if (newCourse) {
                navigationItem.rightBarButtonItem = saveBarButton
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    
    // MARK: - Interface With Previous VC
    
    func setupForNewCourse(withManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        
        newCourse = true
        
        self.managedObjectContext = managedObjectContext
        
        title = "New Course"
        
        
    }
    
    func loadCourse(fromData courseManagedObject: NSManagedObject, withManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        
        newCourse = false
        
        self.managedObjectContext = managedObjectContext
        self.courseManagedObject = courseManagedObject
        
        title = courseManagedObject.valueForKey("name") as? String
    }
    
    
    // MARK: - Color Selector Cell Delegate
    
    func colorSelectorCell(newButtonSelected button: ColorSelectButton) {
        
        let newColor = button.fillColor
        
        if (!newCourse) {
            // Save color
            courseManagedObject!.setValue(newColor, forKey: "color")
            saveManagedObjectContext()
        }
    }
    
    
    // MARK: - Name Text Field Delegate
    
    @IBAction func nameTextFieldValueChanged(sender: UITextField) {
        
        let newValue = sender.text
        
        title = newValue
        
        if (!newCourse) {
            courseManagedObject!.setValue(newValue, forKey: "name")
            saveManagedObjectContext()
        }
    }
    
    @IBAction func nameTextFieldEditingDidBegin(sender: UITextField) {
        
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    // MARK: - Core Data Methods
    
    func saveManagedObjectContext() {
        
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Delete Button
    
    func deleteCourse() {
        
        print("deleteAssignment")
        
        if (!newCourse) {
            // Delete From Managed Context
            managedObjectContext!.deleteObject(courseManagedObject!)
            saveManagedObjectContext()
            
            // Dismiss View
            let navController = navigationController
            navController?.popViewControllerAnimated(true)
            
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (indexPath) {
            
        case deleteButtonCell.indexPath!:
            if (deleteButtonCell.hidden) {
                return 0
            } else {
                return 44
            }
            
        case colorSelectorCell.indexPath!:
            return colorSelectorCell.cellHeight!
            
        default:
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath) {
            
        case deleteButtonCell.indexPath!:
            // Present alert
            let deleteAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let deleteAction = UIAlertAction(
                title: "Delete Course",
                style: .Destructive,
                handler: {(action) in
                    self.deleteCourse()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) in
                self.tableView.deselectRowAtIndexPath(self.deleteButtonCell.indexPath!, animated: true)
            })
            
            deleteAlertController.addAction(deleteAction)
            deleteAlertController.addAction(cancelAction)
            
            presentViewController(deleteAlertController, animated: true, completion: nil)
            break
            
        default:
            break
        }
    }
    
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
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

    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // Get the new view controller using segue.destinationViewController.
    }
    */


}
