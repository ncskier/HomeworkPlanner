//
//  AssignmentsTableViewController.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/27/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

class AssignmentsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, AssignmentCellDelegate_02 {
    
    // Class variables
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    var assignmentDetailOutlineTVC: AssignmentDetailTVC?
    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController?
    var completedFetchedResultsController: NSFetchedResultsController?
    var toDoFetchedResultsController: NSFetchedResultsController?
    var selection: NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Get the managedObjectContext
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "AssignmentData")
        let fetchPredicate = NSPredicate(format: "complete == %@", NSNumber(bool: false))
        fetchRequest.predicate = fetchPredicate
        
        // Add sort descriptors
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        
        // Initialize Fetched Results Controller
        print("managed context: \(managedObjectContext)")
//        toDoFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        toDoFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: "dueDate", cacheName: nil)
        
        // Configure Fetched Results Controller
        toDoFetchedResultsController!.delegate = self
        
        // Perform Fetch
        do {
            try toDoFetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        // Configure Completed Assignments Fetch
        let completedFetchRequest = NSFetchRequest(entityName: "AssignmentData")
        let completedPredicate = NSPredicate(format: "complete == %@", NSNumber(bool: true))
        completedFetchRequest.predicate = completedPredicate
        completedFetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: false)]
//        completedFetchedResultsController = NSFetchedResultsController(fetchRequest: completedFetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        completedFetchedResultsController = NSFetchedResultsController(fetchRequest: completedFetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: "dueDate", cacheName: nil)
        completedFetchedResultsController!.delegate = self
        
        // Perform Fetch
        do {
            try completedFetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        title = "Assignments"
        
        // Select State
        updateActiveResultsController()
        
        // Set priority color if there is none
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        let redValue = standardDefaults.valueForKey("priorityRedColor") as? CGFloat
        let greenValue = standardDefaults.valueForKey("priorityGreenColor") as? CGFloat
        let blueValue = standardDefaults.valueForKey("priorityBlueColor") as? CGFloat
        
        if (redValue == nil || greenValue == nil || blueValue == nil) {
            
            standardDefaults.setValue(CGFloat(1.0), forKey: "priorityRedColor")
            standardDefaults.setValue(CGFloat(0.0), forKey: "priorityGreenColor")
            standardDefaults.setValue(CGFloat(0.0), forKey: "priorityBlueColor")
        }
    }
    
    func updateActiveResultsController() {
        
        switch (stateSegmentedControl.selectedSegmentIndex) {
        case 0:
            fetchedResultsController = toDoFetchedResultsController
            completedFetchedResultsController!.delegate = nil
            toDoFetchedResultsController!.delegate = self
            
            do {
                try toDoFetchedResultsController!.performFetch()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        case 1:
            fetchedResultsController = completedFetchedResultsController
            toDoFetchedResultsController!.delegate = nil
            completedFetchedResultsController!.delegate = self
            
            do {
                try completedFetchedResultsController!.performFetch()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        default:
            print("State Error")
            fetchedResultsController = toDoFetchedResultsController
            completedFetchedResultsController!.delegate = nil
            toDoFetchedResultsController!.delegate = self
            
            do {
                try toDoFetchedResultsController!.performFetch()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func stateSelectorValueChanged(sender: UISegmentedControl) {
        
        updateActiveResultsController()
    }
    
    
    func saveContext() {
        // Save new assignment managed object
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func newAssignmentButtonPressed() {
        
        let navController = UINavigationController(rootViewController: assignmentDetailOutlineTVC!)
        assignmentDetailOutlineTVC!.setupForNewAssignment(withManagedObjectContext: managedObjectContext!)
        
        presentViewController(navController, animated: true, completion: nil)
    }
    
    
    // MARK: - Fetched Results Controller
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch (type) {
            
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            break
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            break
            
        case .Update:
            // Configure cell at index path
            (tableView.dequeueReusableCellWithIdentifier("assignmentCell_02", forIndexPath: indexPath!) as! AssignmentCell_02).configureCell(fromData: fetchedResultsController!.objectAtIndexPath(indexPath!) as! NSManagedObject, withDelegate: self, andManagedObjectContext: managedObjectContext!, indexPath: indexPath!)
            break
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch (type) {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
            
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
            
        default:
            print("ERROR: didChangeSection method error")
        }
        
        print("")
        print("Change section")
    }
    
    
    // MARK: - Assignment Detail Outline Table View Controller Delegate
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    // MARK: - Assignment Cell Delegate
    
    func changePercentComplete(toNewValue newValue: Int, forCellAtIndexPath indexPath: NSIndexPath) {
        
//        if (indexPath != nil) {
            let managedObject = fetchedResultsController?.objectAtIndexPath(indexPath) as? NSManagedObject
            managedObject?.setValue(newValue, forKey: "percentComplete")
            saveContext()
//        }
    }
    
    func assignmentCell(deselectAssignmentCellAtIndexPath indexPath: NSIndexPath) {
        
//        if (indexPath != nil) {
            print("Deselect")
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            
            
//        } else {
//            print("ERROR deselecting assignment cell")
//        }
    }
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selection = indexPath
        performSegueWithIdentifier("assignmentDetailSegue", sender: self)
        
//        print("Did select row at index path: \(indexPath)")
//        let rowAssignmentData = fetchedResultsController?.objectAtIndexPath(indexPath) as? NSManagedObject
//        
//        print("assignment: \(rowAssignmentData)")
        
//        assignmentDetailOutlineTVC!.loadAssignment(fromData: rowAssignmentData!, withManagedObjectContext: managedObjectContext!)
//        navigationController!.pushViewController(assignmentDetailOutlineTVC!, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController!.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fetchedSections = fetchedResultsController!.sections!
        let sectionInfo = fetchedSections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("assignmentCell_02", forIndexPath: indexPath) as? AssignmentCell_02
        
        // Configure the cell...
        let rowAssignmentData = fetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject
        
        cell!.configureCell(fromData: rowAssignmentData, withDelegate: self, andManagedObjectContext: managedObjectContext!, indexPath: indexPath)
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sections = fetchedResultsController?.sections
        let rawDataName = sections![section].name
        
        // Get date from string
        let toDateFormatter = NSDateFormatter()
        toDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZ"
        let date = toDateFormatter.dateFromString(rawDataName)
        
        // Get formatted date string
        let fromDateFormatter = DateFormatHelper.dateFormatterWithDateFormat(DateFormatHelper.formatLocal_EdMMMyyyy!)
        var formattedDate = "Never"
        if (date != nil) {
            formattedDate = fromDateFormatter.stringFromDate(date!)
        }
        
        formattedDate = DateFormatHelper.addTagsToFormattedDate(formattedDate, fromDateFormatter: fromDateFormatter)
        
        // Add Overdue Tag
        if (stateSegmentedControl.selectedSegmentIndex == 0) {
            let now = DateFormatHelper.normalizeDueDate(NSDate())
            if (date!.compare(now) == NSComparisonResult.OrderedAscending) {
                formattedDate = "\(formattedDate) (Overdue)"
            }
        }
        
        return formattedDate
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        /*
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            print("AYYYE")
            return cell.frame.height
        }
        */
        
        return 92
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let deleteObject = fetchedResultsController!.objectAtIndexPath(indexPath)
            
            // Cancel notification
            let alertNotification = deleteObject.valueForKey("notification") as? UILocalNotification
            if (alertNotification != nil) {
                UIApplication.sharedApplication().cancelLocalNotification(alertNotification!)
            }
            
            managedObjectContext!.deleteObject(deleteObject as! NSManagedObject)
            saveContext()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


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

        // Pass the selected object to the new view controller.
        if (segue.identifier == "newAssignmentSegue") {

            let assignmentVC = (newVC as! UINavigationController).topViewController as! AssignmentDetailTVC
            assignmentVC.setupForNewAssignment(withManagedObjectContext: managedObjectContext!)
        }
        else if (segue.identifier == "assignmentDetailSegue") {
            
            let assignmentVC = newVC as! AssignmentDetailTVC
            assignmentVC.loadAssignment(fromData: fetchedResultsController!.objectAtIndexPath(selection!) as! NSManagedObject, withManagedObjectContext: managedObjectContext!)
        }
    }
    
    
    // MARK: - Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
