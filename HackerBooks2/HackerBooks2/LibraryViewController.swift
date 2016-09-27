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

        // Crear el VC
        let vc = BookViewController(model: bt.book!)
        
        // Mostrarlo
        navigationController?.pushViewController(vc, animated: true)
    
    }
}
