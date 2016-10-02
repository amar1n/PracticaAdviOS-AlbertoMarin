//
//  AnnotationCollectionViewCell.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 30/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit

class AnnotationCollectionViewCell: UICollectionViewCell {
    // MARK:  - Properties
    var annotation : Annotation?
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var modificationDateView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var locationView: UIImageView!
    
    //MARK: - Inits
    func myInit(annotation: Annotation) {
        self.annotation = annotation
        
        syncViewsWith(model: annotation)
    }
    
    //MARK: - Lifecycle
    override func prepareForReuse() {
        syncViewsWith(model: nil)
    }
    
    //MARK: - Syncing
    func syncViewsWith(model: Annotation?) {
        locationView.image = nil
        
        photoView.image = model?.photo?.image
        let df = DateFormatter()
        df.dateStyle = .medium
        
        if let m = model {
            if let md : Date = m.modificationDate as Date? {
                modificationDateView.text = df.string(from: md)
            }
            if m.hasLocation {
                locationView.image = UIImage(imageLiteralResourceName: "placemark.png")
            }
            
        }
        titleView.text = model?.text
    }
}
