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

public class Book: NSManagedObject {

    static let entityName = "Book"
    
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
    
    //MARK: - Utils
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
}
