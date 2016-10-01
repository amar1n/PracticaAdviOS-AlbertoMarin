//
//  BookTag+CoreDataProperties.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 1/10/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

extension BookTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookTag> {
        return NSFetchRequest<BookTag>(entityName: "BookTag");
    }

    @NSManaged public var book: Book?
    @NSManaged public var tag: Tag?

}
