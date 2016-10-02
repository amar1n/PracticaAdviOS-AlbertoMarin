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
let FavoriteTagName = "Favoritos"

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
            
            let bt = createBookTag(book: self, tag: tag, context: context)
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
            return authors.last!
        }
        
        return Author(fullName: fullName, context: context)
    }
    
    func findBookTag(book: Book, tag: Tag, context: NSManagedObjectContext) -> BookTag? {
        let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        let p1 = NSPredicate(format: "book == %@", book)
        let p2 = NSPredicate(format: "tag == %@", tag)
        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        let bookTags = try! context.fetch(req)
        
        if bookTags.count > 0 {
            return bookTags.last
        } else {
            return nil
        }
    }

    func createBookTag(book: Book, tag: Tag, context: NSManagedObjectContext) -> BookTag {
        let bt = findBookTag(book: book, tag: tag, context: context)
        guard bt != nil else {
            return BookTag(book: book, tag: tag, context: context)
        }
        return bt!
    }

    func findTag(tagName: String, context: NSManagedObjectContext) -> Tag? {
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.predicate = NSPredicate(format: "name == %@", tagName)
        let tags = try! context.fetch(req)
        
        if tags.count > 0 {
            return tags.last
        } else {
            return nil
        }
    }

    func createTag(tagName: String, context: NSManagedObjectContext) -> Tag {
        let t = findTag(tagName: tagName, context: context)
        guard t != nil else {
            return Tag(name: tagName, context: context)
        }
        return t!
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
            self.addObserver(self, forKeyPath: key, options: [.new, .old], context: nil)
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
        guard let obj = object else {
            return
        }
        guard obj as AnyObject === self
            && keyPath == "favorite"
            && change?[NSKeyValueChangeKey.kindKey] as? UInt == NSKeyValueChange.setting.rawValue else {
                return
        }
        
        let newX = change![NSKeyValueChangeKey.newKey]! as? NSNumber
        if let new = newX {
            if (Bool(new)) {
                let tag = createTag(tagName: FavoriteTagName, context: managedObjectContext!)
                let bt = createBookTag(book: self, tag: tag, context: managedObjectContext!)
                addToBookTags(bt)
            } else {
                let tag = findTag(tagName: FavoriteTagName, context: managedObjectContext!)
                if (tag != nil) {
                    let bt = findBookTag(book: self, tag: tag!, context: managedObjectContext!)
                    if (bt != nil) {
                        managedObjectContext?.delete(bt!)
                    }
                }
            }
        }
        
        let notificationName : Notification.Name = BookDidChange
        sendNotification(name: notificationName)
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

