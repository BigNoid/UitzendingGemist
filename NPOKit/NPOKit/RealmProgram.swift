//
//  RealmProgram.swift
//  NPOKit
//
//  Created by Jeroen Wesbeek on 18/07/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProgram: Object {
    dynamic var mid: String?
    dynamic var name: String?
    dynamic var firstLetter: String? {
        didSet {
            // check if all is well
            let trimmedValue = (firstLetter ?? "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            // make sure we have a first letter
            guard let name = name where trimmedValue.characters.count != 1 else {
                return
            }
            
            // use the first letter of the name instead
            firstLetter = String(name[name.startIndex]).lowercaseString
        }
    }
    dynamic var favorite: Bool = false
    let episodes = List<RealmEpisode>() // one to many relationship
    
    override static func indexedProperties() -> [String] {
        return ["mid"]
    }
}