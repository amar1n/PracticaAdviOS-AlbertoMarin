//
//  Tag+CoreDataProperties.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 27/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag");
    }

    @NSManaged public var name: String?
    @NSManaged public var proxySorting: String?
    @NSManaged public var bookTag: NSSet?

}

// MARK: Generated accessors for bookTag
extension Tag {

    @objc(addBookTagObject:)
    @NSManaged public func addToBookTag(_ value: BookTag)

    @objc(removeBookTagObject:)
    @NSManaged public func removeFromBookTag(_ value: BookTag)

    @objc(addBookTag:)
    @NSManaged public func addToBookTag(_ values: NSSet)

    @objc(removeBookTag:)
    @NSManaged public func removeFromBookTag(_ values: NSSet)

}
