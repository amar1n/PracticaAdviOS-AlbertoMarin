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
import CoreLocation

public class Annotation: NSManagedObject {
//public class Annotation: NSManagedObject, CLLocationManagerDelegate {
    
//    var locationManager: CLLocationManager? = nil
    
    static let entityName = "Annotation"
    
    convenience init(book: Book, text: String, latitude: Double?, longitude: Double?, address: String?, photo: UIImage, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.hasLocation = false
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        self.text = text
        self.book = book
        
        if let la = latitude, let lo = longitude, let ad = address {
            self.location = Location(latitude: la, longitude: lo, address: ad, context: context)
        } else {
            if let la = latitude, let lo = longitude {
                self.location = Location(latitude: la, longitude: lo, context: context)
            } else {
                if let ad = address {
                    self.location = Location(address: ad, context: context)
                } else {
                    self.location = Location(address: "GreySkull!!!", context: context)
                }
            }
        }
        
        self.photo = Photo(annotation: self, image: photo, context: context)
    }

    convenience init(book: Book, text: String, latitude: Double?, longitude: Double?, address: String?, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.hasLocation = false
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        self.text = text
        self.book = book

        if let la = latitude, let lo = longitude, let ad = address {
            self.location = Location(latitude: la, longitude: lo, address: ad, context: context)
        } else {
            if let la = latitude, let lo = longitude {
                self.location = Location(latitude: la, longitude: lo, context: context)
            } else {
                if let ad = address {
                    self.location = Location(address: ad, context: context)
                } else {
                    self.location = Location(address: "GreySkull!!!", context: context)
                }
            }
        }

        self.photo = Photo(annotation: self, context: context)
    }
    
//    //MARK: - CLLocationManagerDelegate
//    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//    }
}

////MARK: - Lifecycle
//extension Annotation {
//    // Se llama una sola vez
//    public override func awakeFromInsert() {
//        super.awakeFromInsert()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//                print("No access")
//            case .authorizedAlways, .authorizedWhenInUse:
//                
//                self.locationManager = CLLocationManager()
//                self.locationManager?.delegate = self
//                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//                self.locationManager?.startUpdatingLocation()
//                
//                print("Access")
//            }
//        } else {
//            print("Location services are not enabled")
//        }
//        
//    }
//    
//    // Se llama un monton de veces
//    public override func awakeFromFetch() {
//        super.awakeFromFetch()
//    }
//    
//    public override func willTurnIntoFault() {
//        super.willTurnIntoFault()
//    }
//}
