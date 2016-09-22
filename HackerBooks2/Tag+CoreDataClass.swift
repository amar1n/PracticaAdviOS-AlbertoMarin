//
//  Tag+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

public class Tag: NSManagedObject {

    static let entityName = "Tag"
        
    convenience init(name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.name = name
        if (self.name == "Favourites") {
            self.proxySorting = "_" + self.name!
        } else {
            self.proxySorting = self.name
        }
    }
}
