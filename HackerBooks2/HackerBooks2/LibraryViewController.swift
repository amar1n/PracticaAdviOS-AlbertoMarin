//
//  LibraryViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 25/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import CoreData

class LibraryViewController: CoreDataTableViewController {

}

//MARK: - DataSource
extension LibraryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooks 2"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "BookTagCell"
        
        let bt = fetchedResultsController?.object(at: indexPath) as! BookTag
        
        // Crear la celda
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        // Configurarla
        cell?.textLabel?.text = bt.book?.title
        
        // Devolverla
        return cell!
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Averiguar el libro
        let bt = fetchedResultsController?.object(at: indexPath) as! BookTag
        print(bt.book?.title)
        
//        // Crear el fetch
//        let req = NSFetchRequest<Book>(entityName: Book.entityName)
//        req.fetchBatchSize = 50
//        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        req.predicate = NSPredicate(format: "title == %@", b.title!)
//        
//        // El FetchedResultsController
//        let fc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: b.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
//
//        // Crear el controlador
//        let notesVC = BookViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>)
//        
//        // Mostrarlo
//        navigationController?.pushViewController(notesVC, animated: true)
    }
}
