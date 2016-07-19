//
//  JSON.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/24/15.
//
//

import Foundation
import SwiftyJSON

extension JSON {
    func getFormattedName() -> String {
        var elements:[String] = []
        
        if let seriesName = self["series"]["name"].string where seriesName.characters.count > 0 {
            elements.append(seriesName)
        }
        
        if let itemName = self["name"].string where itemName.characters.count > 0 {
            let predicate = NSPredicate(format: "SELF contains[cd] %@", itemName)
            let present = elements.contains { predicate.evaluateWithObject($0) }
            if !present && itemName != "NOS Journaal" && elements.count > 0 {
                elements.append(itemName)
            }
        }
        
        return elements.joinWithSeparator(": ")
    }
    
    func getFormattedGenre() -> String {
        var elements:[String] = []
        
        if let genres = self["genres"].array {
            for genre in genres {
                if let genreName = genre.string {
                    let nameElements = genreName.componentsSeparatedByString("/")
                    
                    for nameElement in nameElements {
                        let trimmedNameElement = nameElement.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).capitalizedString
                        
                        let predicate = NSPredicate(format: "SELF contains[cd] %@", trimmedNameElement)
                        let present = elements.contains { predicate.evaluateWithObject($0) }
                        if (!present) {
                            elements.append(trimmedNameElement)
                        }
                    }
                }
            }
        }
        
        return elements.joinWithSeparator(" / ")
    }
}