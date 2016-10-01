//
//  AnnotationsViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 29/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import CoreData

class AnnotationsViewController: CoreDataCollectionViewController {
    
    let cellId = "AnnotationCell"
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let fc = fetchedResultsController else {
            return
        }
        
        let nib = UINib(nibName: "AnnotationCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        if (fc.fetchedObjects?.first as? Annotation) != nil {
            title = "Notas de \((fc.fetchedObjects?.first as! Annotation).book!.title!)"
        } else {
            title = "Notas"
        }
    }
    
    //MARK: - Data Source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let a = fetchedResultsController?.object(at: indexPath) as! Annotation
        
        // Crear la celda
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AnnotationCollectionViewCell
        
        // Configurarla
        cell.observe(annotation: a)
        
        // Devolverla
        return cell
    }
}
