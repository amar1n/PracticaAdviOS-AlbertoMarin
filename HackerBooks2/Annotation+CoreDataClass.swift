//
//  Annotation+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Annotation: NSManagedObject {

    static let entityName = "Annotation"
    
    convenience init(book: Book, text: String, latitude: Double?, longitude: Double?, address: String?, photo: UIImage, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        self.text = text
        self.book = book
        
        if let la = latitude, let lo = longitude, let ad = address {
            self.location = Location(latitude: la, longitude: lo, address: ad, context: context)
        } else {
            if let la = latitude, let lo = longitude {
                self.location = Location(latitude: la, longitude: lo, context: context)
            } else {
                if let ad = address {
                    self.location = Location(address: ad, context: context)
                } else {
                    self.location = Location(address: "GreySkull!!!", context: context)
                }
            }
        }
        
        self.photo = Photo(annotation: self, image: photo, context: context)
    }

    convenience init(book: Book, text: String, latitude: Double?, longitude: Double?, address: String?, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        self.text = text
        self.book = book

        if let la = latitude, let lo = longitude, let ad = address {
            self.location = Location(latitude: la, longitude: lo, address: ad, context: context)
        } else {
            if let la = latitude, let lo = longitude {
                self.location = Location(latitude: la, longitude: lo, context: context)
            } else {
                if let ad = address {
                    self.location = Location(address: ad, context: context)
                } else {
                    self.location = Location(address: "GreySkull!!!", context: context)
                }
            }
        }

        self.photo = Photo(annotation: self, context: context)
    }
}
