//
//  LocationViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 6/10/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    let model: Annotation
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Inits
    init(model: Annotation) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @IBAction func vectorialView(_ sender: AnyObject) {
        self.mapView.mapType = MKMapType.standard;
    }
    
    @IBAction func satelliteView(_ sender: AnyObject) {
        self.mapView.mapType = MKMapType.satellite;
    }
    
    @IBAction func hybridView(_ sender: AnyObject) {
        self.mapView.mapType = MKMapType.hybrid;
    }
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.addAnnotation(self.model)
        
        let region = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 2000000, 2000000)
        self.mapView.setRegion(region, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        let region = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 500, 500)

        let delayInNanoSeconds = UInt64(1) * NSEC_PER_SEC
        let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.mapView.setRegion(region, animated: true)
        })
    }
}
