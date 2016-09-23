//
//  Photo+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Photo: NSManagedObject {

    static let entityName = "Photo"
    
    var image : UIImage? {
        get {
            guard let data = self.photoData else {
                return nil
            }
            return UIImage(data: data as Data)!
        }
        set {
            guard let img = newValue else {
                self.photoData = nil
                return
            }
            self.photoData = UIImagePNGRepresentation(img) as NSData?
        }
    }
    
    convenience init(annotation: Annotation, image: UIImage, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.image = image

        addToAnnotations(annotation)
}

    convenience init(annotation: Annotation, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)

        addToAnnotations(annotation)
    }
}
