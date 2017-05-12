//
//  LocationManager.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/10/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManager: CLLocationManager, CLLocationManagerDelegate{
    
    //Create Shared instance of Location Manager Class
    static let sharedLocationInstance = LocationManager()
    var locationManager:CLLocationManager!
    private var completion: ((String) -> Void)?
    
    //Requests Permission for Location and starts getting users current location
    func determineMyCurrentLocation(completion: @escaping ((String) -> Void)){
        self.completion = completion
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    //Finds users location and shares it using location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            self.locationManager.stopUpdatingLocation()
            if locations.first != nil{
               self.completion!("locations: \(locations.first!)")
            }
        }
    }
    
    //If there is an error while getting the users location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location \(error.localizedDescription)")
    }
}
