//
//  Book+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let BookDidChange = Notification.Name(rawValue: "amarin.BookDidChange")
let BookCoverImageDidDownload = Notification.Name(rawValue: "amarin.BookCoverImageDidDownload")
let BookPDFDidDownload = Notification.Name(rawValue: "amarin.BookPDFDidDownload")

public class Book: NSManagedObject {

    static let entityName = "Book"
    
    //MARK: - Inits
    convenience init(title: String, authors: Authors, tags: Tags, coverUrl: URL, pdfUrl: URL, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.favorite = false
        self.title = title

        for authorFullName in authors {
            let a = createAuthor(fullName: authorFullName, context: context)
            
            addToAuthors(a)
        }

        for tagName in tags {
            let tag = createTag(tagName: tagName, context: context)

            let bt = BookTag(book: self, tag: tag, context: context)
            addToBookTags(bt)
        }

        self.cover = Cover(coverUrl: coverUrl, context: context)
        self.pdf = Pdf(pdfUrl: pdfUrl, context: context)
    }
    
    func createAuthor(fullName: String, context: NSManagedObjectContext) -> Author {
        let req = NSFetchRequest<Author>(entityName: Author.entityName)
        req.predicate = NSPredicate(format: "fullName == %@", fullName)
        let authors = try! context.fetch(req)
        
        if authors.count > 0 {
            return authors[0]
        }
        
        return Author(fullName: fullName, context: context)
    }

    func createTag(tagName: String, context: NSManagedObjectContext) -> Tag {
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.predicate = NSPredicate(format: "name == %@", tagName)
        let tags = try! context.fetch(req)
        
        if tags.count > 0 {
            return tags[0]
        }
        
        return Tag(name: tagName, context: context)
    }

    //MARK:- Notifications
    func sendNotification(name: Notification.Name) {
        let n = Notification(name: name, object: self, userInfo: nil)
        let nc = NotificationCenter.default
        nc.post(n)
    }
}

//MARK: - KVO
extension Book {
    static func observableKeys() -> [String] {
        return ["favorite"]
    }
    
    func setupKVO() {
        // Alta en las notificaciones para algunas propiedades
        for key in Book.observableKeys() {
            self.addObserver(self, forKeyPath: key, options: [], context: nil)
        }
    }
    
    func teardownKVO() {
        // Baja en todas las notificaciones
        for key in Book.observableKeys () {
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else {
            return
        }
        
        if key == "favorite" {
            let notificationName : Notification.Name = BookDidChange
            sendNotification(name: notificationName)
        }
    }
}

//MARK: - Lifecycle
extension Book {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setupKVO()
    }
    
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        setupKVO()
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        teardownKVO()
    }
}

