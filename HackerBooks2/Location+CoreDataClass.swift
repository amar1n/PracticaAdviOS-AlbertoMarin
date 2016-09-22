//
//  Location+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

public class Location: NSManagedObject {

    static let entityName = "Location"
    
    convenience init(latitude: Double, longitude: Double, address: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)

        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }

    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(address: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.address = address
    }
}
