//
//  Annotation+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit

public class Annotation: NSManagedObject {
    
    var locationManager: CLLocationManager? = nil
    
    static let entityName = "Annotation"
    
    //MARK: - Computed properties
    var hasLocation: Bool {
        get {
            return self.location != nil
        }
    }
    
    //MARK:- Inits
    convenience init(book: Book, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        self.book = book
    }
}

extension Annotation : MKAnnotation {
    
    public var title: String? {
        get {
            return "I wrote a note here!!!"
        }
    }
    
    public var subtitle: String? {
        get {
            return self.text
        }
    }
    
    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake((self.location?.latitude)!, (self.location?.longitude)!)
        }
    }
}

//MARK: - Lifecycle
extension Annotation {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        let status = CLLocationManager.authorizationStatus()
        if (CLLocationManager.locationServicesEnabled() &&
            ((status == CLAuthorizationStatus.authorizedAlways) || (status == CLAuthorizationStatus.notDetermined))) {
            // Tenemos localizacion!!!
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.requestAlwaysAuthorization()
            self.locationManager?.startUpdatingLocation()
            
            // Solo interesan datos recientes
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.zapLocationManager()
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    //MARK:- Utils
    func zapLocationManager() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil
    }
    
}

//MARK:- CLLocationManagerDelegate
extension Annotation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Lo paramos
        zapLocationManager()
        
        if (!self.hasLocation) {
            // Agarramos la ultima localizacion
            let lastLocation = locations.last
            
            // Creamos la Location
            var location: Location? = nil
            if (lastLocation != nil) {
                location = findLocationWith(cllocation: lastLocation!)
                if location == nil {
                    location = Location(location: lastLocation!, context: managedObjectContext!)
                } else {
                    print("..........Reutilizamos la location")
                }
            } else {
                print("..........lastLocation es nil")
            }
            self.location = location

        } else {
            print("Aqui nunca deberia entrar!!!")
        }
    }
    
    func findLocationWith(cllocation: CLLocation) -> Location? {
        let req = NSFetchRequest<Location>(entityName: Location.entityName)
        let latitudePredicate = NSPredicate(format: "abs(latitude) - abs(%lf) < 0.001", cllocation.coordinate.latitude)
        let longitudePredicate = NSPredicate(format: "abs(longitude) - abs(%lf) < 0.001", cllocation.coordinate.longitude)
        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latitudePredicate, longitudePredicate])
        let results = try! self.managedObjectContext!.fetch(req)
        
        if results.count > 0 {
            return results.last
        }
        return nil
    }
    
}
