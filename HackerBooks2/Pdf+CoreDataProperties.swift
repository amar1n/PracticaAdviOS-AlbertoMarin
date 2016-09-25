//
//  Pdf+CoreDataProperties.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 24/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

extension Pdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pdf> {
        return NSFetchRequest<Pdf>(entityName: "Pdf");
    }

    @NSManaged public var pdfData: NSData?
    @NSManaged public var book: Book?

}
