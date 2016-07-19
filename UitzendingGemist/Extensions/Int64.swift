//
//  Int64.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/24/15.
//
//

import Foundation

extension Int64 {
    func getFormattedDuration() -> String {
        var duration = "\(self) seconden"
        let days =  Int(floor(Double(self / 86400)))
        let daySeconds = days * 86400
        let hours = Int(floor(Double((self - daySeconds) / 3600)))
        let hourSeconds = hours * 3600
        let minutes = Int(floor(Double((self - daySeconds - hourSeconds) / 60)))
        
        var elements:[String] = []
        
        if (days == 1) {
            elements.append("\(days) dag")
        } else if (days > 1) {
            elements.append("\(days) dagen")
        }
        
        if (hours > 0) {
            elements.append("\(hours) uur")
        }
        
        if (minutes == 1) {
            elements.append("\(minutes) minuut")
        } else if (minutes > 1) {
            elements.append("\(minutes) minuten")
        }
        
        if (elements.count > 0) {
            duration = elements.joinWithSeparator(", ")
        }
        
        return "Speeltijd: \(duration)"
    }
    
    func getFormattedTimesViewed() -> String {
        return "\(self) keer bekeken"
    }
}