//
//  AssignmentData.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 9/27/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class AssignmentData: NSObject {
    
    var name: String = ""
    var info: String = ""           // Extra information about assignment
    var percentComplete: Int = 0    // % of assignment completed
//    var dueDate = NSDate()
    
    
    override var description: String {
        return "\(name) - \(info) - \(percentComplete)%\n"
    }
    
    override init() {
        
        self.name = ""
        self.info = ""
    }
    
    init(withName name: String, info: String) {
        
        self.name = name
        self.info = info
    }
    
//    init(withName name: String, info: String, dueDate: NSDate) {
//        
//        self.name = name
//        self.info = info
//        self.dueDate = dueDate
//    }
    
}
