//
//  PdfViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 28/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {

    var model : Book

    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        title = self.model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Outlets
    @IBOutlet weak var browserView: UIWebView!
    
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
        bookObserver = _nc.addObserver(forName: BookPDFDidDownload, object: book.pdf, queue: nil) { (n: Notification) in
            self.syncViewWithModel()
        }
    }
    
    func stopObserving(book: Book) {
        _nc.removeObserver(bookObserver)
    }
    
    //MARK: - Syncing
    func syncViewWithModel() {
        browserView.load(model.pdf?.content as! Data, mimeType: "application/pdf", textEncodingName: "", baseURL: NSURL() as URL)
    }
}
