//
//  NSDate.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/24/15.
//
//

import Foundation
import UIKit

extension NSDate {
    func getFormattedDate() -> String {
        var date = ""
        
        // get the number of hours and minutes for todays date
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "nl_NL")
        
        // get difference from today
        let diffDateComponents = NSCalendar.currentCalendar().components([.Year, .Minute], fromDate: self, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
        
        // format date
        if diffDateComponents.year > 0 {
            dateFormatter.dateFormat = "EEE dd MMM YYYY"
            date = dateFormatter.stringFromDate(self)
        } else {
            dateFormatter.dateFormat = "EEE dd MMM HH:mm"
            date = dateFormatter.stringFromDate(self)
        }
        
        // return formatted date
        return date
    }
}