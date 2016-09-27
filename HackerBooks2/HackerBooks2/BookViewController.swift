//
//  BookViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 26/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    var model : Book

    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Outlets
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    
    //MARK: - Actions
    @IBAction func readBook(_ sender: AnyObject) {
    }

    @IBAction func switchFavorite(_ sender: AnyObject) {
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
    }
    
    func stopObserving(book: Book) {
        _nc.removeObserver(bookObserver)
    }

    //MARK: - Syncing
    func syncViewWithModel() {
        coverView.image = model.cover?.image
    }
    
    func syncModelWithView() {
        model.cover?.image = coverView.image!
    }
}
