//
//  Cover+CoreDataProperties.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 2/10/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

extension Cover {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cover> {
        return NSFetchRequest<Cover>(entityName: "Cover");
    }

    @NSManaged public var coverData: NSData?
    @NSManaged public var coverURL: String?
    @NSManaged public var book: Book?

}
