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
    
    var image: UIImage {
        get {
            guard let d = coverData else {
                let mainBundle = Bundle.main
                let defaultCover = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
                let ad = AsyncData(url: URL(string: self.coverURL!)!, defaultData: try! Data(contentsOf: defaultCover))
                ad.delegate = self
                return UIImage(data: ad.data)!
            }
            return UIImage(data: d as Data)!
        }
        set {
            coverData = UIImagePNGRepresentation(newValue) as NSData?
        }
    }
    
    convenience init(coverUrl: URL, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Cover.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)

        self.coverURL = coverUrl.absoluteString
    }

    func sendNotification(name: Notification.Name) {
        let n = Notification(name: name, object: self, userInfo: nil)
        let nc = NotificationCenter.default
        nc.post(n)
    }
}

//MARK: - AsyncDataDelegate
extension Cover: AsyncDataDelegate {
    
    public func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        self.coverData = sender.data as NSData?

        let notificationName : Notification.Name = BookCoverImageDidDownload
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
