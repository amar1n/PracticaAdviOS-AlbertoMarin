//
//  AppDelegate.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 19/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import CoreData

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
        
        // Creamos el rootVC
        let nVC = AMGViewController()
        let navVC = UINavigationController(rootViewController: nVC)
        
        // Creamos la window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Encasquetamos el rootVC a la window y mostramos
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
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
    
    //MARK: - Utils
    func cleanUp() {
        // Clean up all local caches
        do {
            try model.dropAllData()
        } catch {
            print("Se tiró 3 el borrado de la BBDD!!!")
        }
        AsyncData.removeAllLocalFiles()
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
