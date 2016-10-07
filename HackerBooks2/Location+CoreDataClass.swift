//
//  Location+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 21/9/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import AddressBookUI

public class Location: NSManagedObject {
    
    static let entityName = "Location"
    
    convenience init(latitude: Double, longitude: Double, address: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(address: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.address = address
    }
    
    convenience init(location: CLLocation, context: NSManagedObjectContext) {
        // Creamos la location...
        let entity = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        let coder = CLGeocoder()
        
        coder.reverseGeocodeLocation(location, completionHandler: {(stuff, error)->Void in
            
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            
            if (stuff?.count)! > 0 {
                print("............Si Placemarks! \(stuff?.last?.description)")
                if let lines: Array<String> = stuff?.last?.addressDictionary?["FormattedAddressLines"] as? Array<String> {
                    let placeString = lines.joined(separator: ", ")
                    self.address = placeString
                }
            }
            else {
                print("........No Placemarks!")
            }
            
        })
    }
}
