//
//  Cover+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Cover: NSManagedObject {

    static let entityName = "Cover"
    
    var coverWrapper: AsyncData? = nil
    
    var image: UIImage {
        get {
            return UIImage(data: (self.coverWrapper?.data)!)!
        }
        set {
            coverData = UIImagePNGRepresentation(newValue) as NSData?
        }
    }
    
    convenience init(coverUrl: URL, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Cover.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        let mainBundle = Bundle.main
        let defaultCover = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!        
        self.coverWrapper = AsyncData(url: coverUrl, defaultData: try! Data(contentsOf: defaultCover))
    }
}
