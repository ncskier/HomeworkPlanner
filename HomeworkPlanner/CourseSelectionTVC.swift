//
//  CourseSelectionTVC.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/13/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

protocol CourseSelectionTVCDelegate {
    
    func setSelectedCourse(toCourse courseManagedObject: NSManagedObject)
}

class CourseSelectionTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var coursesFetchedResultsController: NSFetchedResultsController?
    var managedObjectContext: NSManagedObjectContext?
    var selectedCourse: NSManagedObject?
    var delegate: CourseSelectionTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Set Title
        title = "Select Course"
        
        // Get ManagedObjextContext
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Fetch Courses
        let fetchRequest = NSFetchRequest(entityName: "CourseData")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        coursesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        coursesFetchedResultsController!.delegate = self
        
        do {
            try coursesFetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    // MARK: - Interface with previous VC's
    func configure(withSelectedCourse selectedCourse: NSManagedObject?, andDelegate delegate: CourseSelectionTVCDelegate) {
        
        self.selectedCourse = selectedCourse
        self.delegate = delegate
    }
    
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch (type) {
            
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            break
            
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            break
            
        default:
            print("ERROR: didChangeSection with type = \(type)")
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch (type) {
            
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            break
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            break
            
        case .Update:
            // Configure cell at index path
            configureCourseCell(tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath!) as! CourseCell, atIndexPath: indexPath!)
            break
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func configureCourseCell(cell: CourseCell, atIndexPath indexPath: NSIndexPath) {
        let courseManagedObject = coursesFetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject
            
        cell.configureCell(fromManagedObject: courseManagedObject)
        
        if (courseManagedObject == selectedCourse) {
            cell.accessoryType = .Checkmark
        } else {
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let courseManagedObject = coursesFetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject
        if (delegate != nil) {
            delegate!.setSelectedCourse(toCourse: courseManagedObject)
        }
        
        navigationController!.popViewControllerAnimated(true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return coursesFetchedResultsController!.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sections = coursesFetchedResultsController!.sections
        let currentSectionInfo = sections![section]
        
        return currentSectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as! CourseCell

        // Configure the cell...
//        let courseManagedObject = coursesFetchedResultsController!.objectAtIndexPath(indexPath)
//        cell.configureCell(fromManagedObject: courseManagedObject as! NSManagedObject)
        configureCourseCell(cell, atIndexPath: indexPath)

        return cell
    }

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
    }
    */

}
