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
    
    var book: Book?

    //MARK: - Inits
    func myInit(book: Book) {
        self.book = book
    }
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nib = UINib(nibName: "AnnotationCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title = "Notas de \(book!.title!)"
        
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(AnnotationsViewController.addNewAnnotation))
        self.navigationItem.rightBarButtonItem = add;
    }
    
    //MARK: - Utils
    func addNewAnnotation() {
        let note = Annotation(book: self.book!, context: fetchedResultsController!.managedObjectContext)
        
        let aVC = AnnotationViewController(model: note, isNew: true)
        navigationController?.pushViewController(aVC, animated: true)
    }
    
    //MARK: - Data Source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        let a = fetchedResultsController!.object(at: indexPath) as! Annotation
        
        // Crear la celda
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AnnotationCollectionViewCell
        
        // Configurarla
        cell.myInit(annotation: a)
        
        // Devolverla
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Averiguar la nota
        let a = fetchedResultsController?.object(at: indexPath) as! Annotation
        
        // Crear el VC
        let vc = AnnotationViewController(model: a, isNew: false)
        
        // Mostrarlo
        navigationController?.pushViewController(vc, animated: true)
    }
}
