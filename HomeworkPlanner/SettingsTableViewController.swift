//
//  SettingsTableViewController.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/27/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var prioritizeColorTitleCell: UITableViewCell!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var tintView: UIView!
    
    let alphaValue: CGFloat = 0.2
    var redValue: CGFloat = 1.0
    var greenValue: CGFloat = 0.0
    var blueValue: CGFloat = 0.0
    var saveButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        title = "Settings"
        
    }

    
    override func viewWillAppear(animated: Bool) {
        // Called after ViewDidLoad
        
        // Load priority color
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        // Set priority color to the default
        var priorityColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: alphaValue)
        
        if let redValue = standardDefaults.valueForKey("priorityRedColor") as? CGFloat {
            
            self.redValue = redValue
            greenValue = standardDefaults.valueForKey("priorityGreenColor") as! CGFloat
            blueValue = standardDefaults.valueForKey("priorityBlueColor") as! CGFloat
            
            priorityColor = UIColor(red: self.redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
        }
        
        // Set up title cell
        tintView.backgroundColor = priorityColor
        
        // Set up save button
        saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed")
        
        
        // Set initial slider values
        redSlider.value = Float(redValue)
        greenSlider.value = Float(greenValue)
        blueSlider.value = Float(blueValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider) {
        
        redValue = CGFloat(sender.value)
        tintView.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
        
        // Add save button
        if (navigationItem.rightBarButtonItem == nil) {
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider) {
        
        greenValue = CGFloat(sender.value)
        tintView.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
        
        // Add save button
        if (navigationItem.rightBarButtonItem == nil) {
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider) {
        
        blueValue = CGFloat(sender.value)
        tintView.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
        
        // Add save button
        if (navigationItem.rightBarButtonItem == nil) {
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    
    func saveButtonPressed() {
        
        // Save current color values
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        standardDefaults.setValue(redValue, forKey: "priorityRedColor")
        standardDefaults.setValue(greenValue, forKey: "priorityGreenColor")
        standardDefaults.setValue(blueValue, forKey: "priorityBlueColor")
        
        // Hide save button
        navigationItem.rightBarButtonItem = nil
    }
    

    // MARK: - Table view data source
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
    }
    */

}
