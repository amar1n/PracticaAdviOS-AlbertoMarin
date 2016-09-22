//
//  Author+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

public class Author: NSManagedObject {

    static let entityName = "Author"
    
    convenience init(fullName: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.fullName = fullName
    }
}
