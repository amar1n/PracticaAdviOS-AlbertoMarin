//
//  AppDelegate.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 19/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import CoreData

// 30 Book
// 35 Author
// 62 Tag
// 80 BookTag

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let model = CoreDataStack(modelName: "Model")!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Create the window
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        // Create the model
        self.model.performBackgroundBatchOperation(proccessTheJSON)
        self.model.autoSave(10)
        
        do {
            // Configuramos controladores, combinadores y sus delegados según el tipo de dispositivo
            let rootVC: UIViewController
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                rootVC = rootViewControllerForPhone()
            default:
                throw LibraryErrors.deviceNotSupported
            }
            
            // Asignar el rootVC
            window?.rootViewController = rootVC
            
            // Hacer visible & key a la window
            window?.makeKeyAndVisible()
            
            return true
        } catch {
            fatalError("Error while did finish launching with options")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        model.save()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        cleanUpLocalCaches()
    }
    
    //MARK: - Utils
//    func rootViewControllerForPad() -> UIViewController {
//        // Controladores
//        let index = NSUserDefaults.standardUserDefaults().indexPathForKey(BookKey)
//        let libraryVC = LibraryViewController(model: nil, selectedRow: index, autoSelectRow: true)
//        let libraryNav = UINavigationController(rootViewController: libraryVC)
//        
//        // let initialBook = model.book(atIndex: 0)!
//        let bookVC = BookViewController(model: nil)
//        let bookNav = UINavigationController(rootViewController: bookVC)
//        
//        // Combinadores
//        let splitVC = UISplitViewController()
//        splitVC.viewControllers = [libraryNav, bookNav]
//        
//        // Delegados
//        splitVC.delegate = bookVC
//        libraryVC.setDelegate(bookVC)
//        
//        // Asignar el mismo tipo de letra en todas las barras de navegación
//        let navigationBarAppearace = UINavigationBar.appearance()
//        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Star Jedi", size: 20)!]
//        
//        return splitVC
//    }

    func rootViewControllerForPhone() -> UIViewController {
        // Creamos el fetchRequest
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 24
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.proxySorting", ascending: true), NSSortDescriptor(key: "book.title", ascending: true)]
        
        // Creamos el fetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: model.context, sectionNameKeyPath: "tag.proxySorting", cacheName: nil)

        // Controladores
        let libraryVC = LibraryViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
        
        // Combinadores
        let libraryNav = UINavigationController(rootViewController: libraryVC)
        
        // Delegados
        // libraryVC.setDelegate(libraryVC)
        
        return libraryNav
    }
    
    func cleanUpLocalCaches() {
        AsyncData.removeAllLocalFiles()
    }

    func cleanUpDataBase() {
        do {
            try model.dropAllData()
        } catch {
            print("Se tiró 3 el borrado de la BBDD!!!")
        }
    }

    func cleanUp() {
        cleanUpLocalCaches()
        cleanUpDataBase()
    }
    
    func proccessTheJSON(_ workerContext: NSManagedObjectContext) {
        // Limpiar toda la data de prueba
        cleanUp()
        
        do{
            guard let url = Bundle.main.url(forResource: "books_readable", withExtension: "json") else {
                fatalError("Unable to read json file!")
            }
            
            let data = try Data(contentsOf: url)
            let jsonDicts = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONArray
            
            var _ = try decode(books: jsonDicts, context: workerContext)
            
//            let req = NSFetchRequest<Book>(entityName: Book.entityName)
//            req.fetchBatchSize = 50
//            let books = try! workerContext.fetch(req)
//            
//            // Unas annotations
//            let defaultImage = UIImage(imageLiteralResourceName: "emptyBookCover.png")
//            let _ = Annotation(book: books[0],
//                               text: "Hello World!!!",
//                               latitude: 41.467273,
//                               longitude: 2.091366,
//                               address: nil,
//                               photo: defaultImage,
//                               context: workerContext)
            
            try workerContext.save()
        }catch {
            fatalError("Error while loading model")
        }
    }
}
