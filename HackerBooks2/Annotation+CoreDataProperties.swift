//
//  Annotation+CoreDataProperties.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 2/10/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

extension Annotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Annotation> {
        return NSFetchRequest<Annotation>(entityName: "Annotation");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var book: Book?
    @NSManaged public var location: Location?
    @NSManaged public var photo: Photo?

}
