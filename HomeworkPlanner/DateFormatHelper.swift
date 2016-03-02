//
//  DateFormatHelper.swift
//  HomeworkPlanner
//
//  Created by Brandon Walker on 11/7/15.
//  Copyright © 2015 Brandon Walker. All rights reserved.
//

import UIKit

class DateFormatHelper: NSObject {
    
    static let formatLocal_EdMMMyyyy = NSDateFormatter.dateFormatFromTemplate("EdMMMyyyy", options: 0, locale: NSLocale.currentLocale())
    
    static let formatLocal_EdMMMyyyyhhmma = NSDateFormatter.dateFormatFromTemplate("EdMMMyyyyhhmma", options: 0, locale: NSLocale.currentLocale())
    
    
    
    class func dateFormatterWithDateFormat(dateFormat: String) -> NSDateFormatter {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
    
    
    // Get rid of seconds/minutes (only store month, day, yr)
    class func normalizeDueDate(date: NSDate) -> NSDate {
        
        // Convert date to string
        let formatter = DateFormatHelper.dateFormatterWithDateFormat(DateFormatHelper.formatLocal_EdMMMyyyy!)
        let normalizedString = formatter.stringFromDate(date)
        
        // Convert string into date
        let normalizedDate = formatter.dateFromString(normalizedString)
        
        print("")
        print("Date : \(date)")
        print("nDate: \(normalizedDate!)")
        
        return normalizedDate!
    }
    
    // Normalize Time Interval to Minutes (cut off seconds)
    class func normalizeTimeIntervalToMinutes(timeInterval: NSTimeInterval) -> NSTimeInterval {
        
        let remainder = timeInterval % 60.0       // 60 seconds in a minute
        
        let normalizedTimeInterval = timeInterval - remainder
        return normalizedTimeInterval
    }
    
    // Add Today and Tomorrow Tags to formatted dates
    class func addTagsToFormattedDate(formattedDate: String, fromDateFormatter: NSDateFormatter) -> String {
        
        var newFormattedDate = formattedDate
        
        // Test for "today" and "tomorrow"
        let todayString = fromDateFormatter.stringFromDate(NSDate())
        let tomorrowString = fromDateFormatter.stringFromDate(NSDate(timeIntervalSinceNow: 86400))  // 86400 seconds in a day
        
        switch (formattedDate) {
        case todayString:
            newFormattedDate += " (Today)"
            break
        case tomorrowString:
            newFormattedDate += " (Tomorrow)"
            break
        default:
            break
        }
        
        return newFormattedDate
    }
    
}
