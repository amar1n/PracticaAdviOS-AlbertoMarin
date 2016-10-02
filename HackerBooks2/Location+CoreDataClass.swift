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
                print("............Si Placemarks!")
            }
            else {
                print("........No Placemarks!")
            }
            
        })
        
        
        //        NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:[AMGLocation entityName]];
        //        NSPredicate* latitude = [NSPredicate predicateWithFormat:@"abs(latitude) - abs(%lf) < 0.001", location.coordinate.latitude];
        //        NSPredicate* longitude = [NSPredicate predicateWithFormat:@"abs(longitude) - abs(%lf) < 0.001", location.coordinate.longitude];
        //        req.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ latitude, longitude ]];
        //        NSError* error = nil;
        //        NSArray* results = [note.managedObjectContext executeFetchRequest:req error:&error];
        //        NSAssert(results, @"Error al buscar!!!");
        //        if ([results count]) {
        //            // La aprovechamos
        //            AMGLocation* found = [results lastObject];
        //            return found;
        //        }
        //        else {
        //            // Creamos la location...
        //            AMGLocation* loc = [self insertInManagedObjectContext:note.managedObjectContext];
        //            loc.latitudeValue = location.coordinate.latitude;
        //            loc.longitudeValue = location.coordinate.longitude;
        //            [loc addNotesObject:note];
        //
        //            // Creamos la direccion...
        //            CLGeocoder* coder = [CLGeocoder new];
        //            [coder reverseGeocodeLocation:location
        //                completionHandler:^(NSArray<CLPlacemark*>* _Nullable placemarks, NSError* _Nullable error) {
        //                if (error) {
        //                NSLog(@"Error while obtaining address!!!\n%@", error);
        //                }
        //                else {
        //                loc.address = ABCreateStringWithAddressDictionary([[placemarks lastObject] addressDictionary], YES);
        //                }
        //                
        //                }];
        //            
        //            // Creamos el map snapshot...
        //            loc.mapSnapshot = [AMGMapSnapshot mapSnapshotForLocation:loc];
        //            
        //            return loc;
        //        }
        
    }
}


