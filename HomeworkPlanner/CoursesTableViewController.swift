//
//  CoursesTableViewController.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/12/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

class CoursesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // Class variables
    var managedObjectContext: NSManagedObjectContext?
    var coursesFetchedResultsController: NSFetchedResultsController?
    var selection: NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Set title
        title = "Courses"
        
        // Get the managedObjectContext
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "CourseData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        coursesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        coursesFetchedResultsController!.delegate = self
        
        // Perform Fetch
        do {
            try coursesFetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
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
            (tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath!) as! CourseCell).configureCell(fromManagedObject: coursesFetchedResultsController!.objectAtIndexPath(indexPath!) as! NSManagedObject)
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
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return coursesFetchedResultsController!.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (coursesFetchedResultsController!.sections!.count > 0) {
            let sectionInfo = coursesFetchedResultsController!.sections![section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as? CourseCell

        // Configure the cell...
        
        let courseManagedObject = coursesFetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject
        cell!.configureCell(fromManagedObject: courseManagedObject)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("SELECT")
        selection = indexPath
        
        performSegueWithIdentifier("courseDetailSegue", sender: self)
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
            managedObjectContext!.deleteObject(coursesFetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject)
            saveManagedObjectContext()
            
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
        // Pass the selected object to the new view controller.
        let newVC = segue.destinationViewController
        
        // Pass the selected object to the new view controller.
        if (segue.identifier == "newCourseSegue") {
            
            let courseVC = (newVC as! UINavigationController).topViewController as! CourseDetailTVC
            courseVC.setupForNewCourse(withManagedObjectContext: managedObjectContext!)
        }
        else if (segue.identifier == "courseDetailSegue") {
            
            let courseVC = newVC as! CourseDetailTVC
            
            print("courseFetchedResultsController: \(coursesFetchedResultsController)")
            print("selection: \(selection)")
            print("selected managed object: \(coursesFetchedResultsController?.objectAtIndexPath(selection!) as? NSManagedObject)")
            print("managedObjectContext: \(managedObjectContext)")
            
            courseVC.loadCourse(fromData: coursesFetchedResultsController!.objectAtIndexPath(selection!) as! NSManagedObject, withManagedObjectContext: managedObjectContext!)
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
    
    
    // MARK: - Memory
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
