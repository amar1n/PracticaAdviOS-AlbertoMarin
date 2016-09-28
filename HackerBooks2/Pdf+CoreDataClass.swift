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
    
    var content: NSData {
        get {
            guard let d = pdfData else {
                let mainBundle = Bundle.main
                let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
                let ad = AsyncData(url: URL(string: self.pdfURL!)!, defaultData: try! Data(contentsOf: defaultPdf))
                ad.delegate = self
                return NSData(data: ad.data)
            }
            return NSData(data: d as Data)
        }
        set {
            self.pdfData = newValue
        }
    }

    convenience init(pdfUrl: URL, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.pdfURL = pdfUrl.absoluteString
    }

    func sendNotification(name: Notification.Name) {
        let n = Notification(name: name, object: self, userInfo: nil)
        let nc = NotificationCenter.default
        nc.post(n)
    }
}

//MARK: - AsyncDataDelegate
extension Pdf: AsyncDataDelegate {
    
    public func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        self.pdfData = sender.data as NSData?
        
        let notificationName : Notification.Name = BookPDFDidDownload
        sendNotification(name: notificationName)
    }
    
    public func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        return true
    }
    
    public func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        print("Starting with \(url)")
    }
    
    public func asyncData(_ sender: AsyncData, didFailLoadingFrom url: URL, error: NSError) {
        print("Error loading \(url).\n \(error)")
    }
}
