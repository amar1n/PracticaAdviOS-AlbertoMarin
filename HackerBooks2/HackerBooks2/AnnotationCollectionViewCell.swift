//
//  AnnotationCollectionViewCell.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 30/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit

class AnnotationCollectionViewCell: UICollectionViewCell {
    
    static func observableKeys() -> [String] {
        return [ "text", "modificationDate", "photo.image", "location", "location.latitude", "location.longitude", "location.address" ]
    }
    
    // MARK:  - Properties
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var modificationDateView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var locationView: UIImageView!
    
    //MARK: - Lifecycle
    override func prepareForReuse() {
        syncViewsWith(model: nil)
    }
    
    // Esto no funciona
    //    deinit {
    //        print("...............deinit")
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    //MARK: - Syncing
    func syncViewsWith(model: Annotation?) {
        photoView.image = model?.photo?.image
        let df = DateFormatter()
        df.dateStyle = .medium
        modificationDateView.text = df.string(from: model?.modificationDate as! Date)
        titleView.text = model?.text
        
        locationView.image = nil
        if (model?.hasLocation)! {
            locationView.image = UIImage(imageLiteralResourceName: "placemark.png")
        }
    }
    
    //MARK: - KVO
    func observe(annotation: Annotation) {
        // Observar ciertas propiedades...
        for key in AnnotationCollectionViewCell.observableKeys () {
            annotation.addObserver(self, forKeyPath: key, options: NSKeyValueObservingOptions.new, context: nil)
        }
        
        syncViewsWith(model: annotation)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object {
            let bFlag: Bool = obj is Annotation
            if bFlag {
                syncViewsWith(model: (obj as! Annotation))
            }
        }
    }
}
