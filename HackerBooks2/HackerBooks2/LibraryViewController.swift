//
//  LibraryViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 25/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import CoreData

let lastBookTagViewed = "LastBookTagViewed"

let searchController = UISearchController(searchResultsController: nil)

class LibraryViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooks 2"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Título", "Etiqueta", "Autores"]
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }

    func saveTheBookTagViewed(bookTag: BookTag) {
        let uri = bookTag.objectID.uriRepresentation()
        UserDefaults.standard.set(uri, forKey: lastBookTagViewed)
    }
}

extension LibraryViewController {
    
    //MARK: - CoreDataTableViewController
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
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Averiguar el libro
        let bt = fetchedResultsController?.object(at: indexPath) as! BookTag
        
        // Recordar el libro
        saveTheBookTagViewed(bookTag: bt)
        
        // Crear el VC
        let vc = BookViewController(model: bt.book!)
        
        // Mostrarlo
        navigationController?.pushViewController(vc, animated: true)
    }
}

////MARK: - UISearchBarDelegate
extension LibraryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

//MARK: - UISearchResultsUpdating
extension LibraryViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        guard let frc = fetchedResultsController else {
            return
        }
        if searchText.isEmpty {
            frc.fetchRequest.predicate = nil
        } else {
            switch searchController.searchBar.selectedScopeButtonIndex {
            case 0:
                frc.fetchRequest.predicate = NSPredicate(format: "book.title contains[c] %@", searchText)
            case 1:
                frc.fetchRequest.predicate = NSPredicate(format: "tag.name contains[c] %@", searchText)
            case 2:
                frc.fetchRequest.predicate = NSPredicate(format: "book.authors.fullName contains[c] %@", searchText)
            default:
                frc.fetchRequest.predicate = nil
            }
        }
        executeSearch()
        tableView.reloadData()
    }
}

