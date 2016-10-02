//
//  BookViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 26/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import CoreData

class BookViewController: UIViewController {
    
    var model : Book
    
    //MARK: - Inits
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        title = self.model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Outlets
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    
    //MARK: - Actions
    @IBAction func readBook(_ sender: AnyObject) {
        let pVC = PdfViewController(model: model)
        navigationController?.pushViewController(pVC, animated: true)
    }
    
    @IBAction func switchFavorite(_ sender: AnyObject) {
        model.favorite = !model.favorite
    }
    
    @IBAction func viewAnnotations(_ sender: AnyObject) {
        // Creamos el fetchRequest
        let fr = NSFetchRequest<Annotation>(entityName: Annotation.entityName)
        fr.fetchBatchSize = 24
        fr.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false), NSSortDescriptor(key: "creationDate", ascending: false)]
        fr.predicate = NSPredicate(format: "book == %@", model)
        
        // Creamos el fetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: model.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Layout
        let l = UICollectionViewFlowLayout.init()
        l.itemSize = CGSize(width: 140, height: 150)
        l.scrollDirection = .vertical
        l.minimumLineSpacing = 10
        l.minimumInteritemSpacing = 10
        l.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        // Controlador
        let aVC = AnnotationsViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, layout: l)
        aVC.myInit(book: model)
        navigationController?.pushViewController(aVC, animated: true)
    }
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObserving(book: model)
        syncViewWithModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving(book: model)
    }
    
    //MARK: - Notifications
    let _nc = NotificationCenter.default
    var bookObserver : NSObjectProtocol?
    
    func startObserving(book: Book) {
        bookObserver = _nc.addObserver(forName: BookCoverImageDidDownload, object: book.cover, queue: nil) { (n: Notification) in
            self.syncViewWithModel()
        }
        
        bookObserver = _nc.addObserver(forName: BookDidChange, object: book, queue: nil) { (n: Notification) in
            self.syncViewWithModel()
        }
    }
    
    func stopObserving(book: Book) {
        _nc.removeObserver(bookObserver)
    }
    
    //MARK: - Syncing
    func syncViewWithModel() {
        coverView.image = model.cover?.image
        title = model.title
        if model.favorite {
            favoriteItem.title = "★"
        } else {
            favoriteItem.title = "☆"
        }
    }
}
