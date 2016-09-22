//
//  Pdf+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData

public class Pdf: NSManagedObject {

    static let entityName = "Pdf"
    
    var pdfWrapper: AsyncData? = nil

    var pdf: NSData {
        get {
            return NSData(data: (self.pdfWrapper?.data)!)
        }
        set {
            self.pdfData = newValue
        }
    }

    convenience init(pdfUrl: URL, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        let mainBundle = Bundle.main
        let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
        self.pdfWrapper = AsyncData(url: pdfUrl, defaultData: try! Data(contentsOf: defaultPdf))
    }
}
