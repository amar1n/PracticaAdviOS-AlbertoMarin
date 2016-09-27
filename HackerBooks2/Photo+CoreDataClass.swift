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
    
    // Propiedad computada
    var image : UIImage? {
        get {
            guard let data = photoData else {
                return nil
            }
            return UIImage(data: data as Data)!
        }
        set {
            guard let img = newValue else {
                photoData = nil
                return
            }
            photoData = UIImagePNGRepresentation(img) as NSData?
        }
    }
    
    convenience init(annotation: Annotation, image: UIImage, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)

        addToAnnotations(annotation)
        
        self.image = image
    }

    convenience init(annotation: Annotation, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        addToAnnotations(annotation)
    }

    func sendNotification(name: Notification.Name) {
        let n = Notification(name: name, object: self, userInfo: nil)
        let nc = NotificationCenter.default
        nc.post(n)
    }
}
