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
import UserNotifications

class LocationManager: CLLocationManager {
    
    //Create Shared instance of Location Manager Class
    static let sharedLocationInstance = LocationManager()
    var locationManager:CLLocationManager!
    var region: CLCircularRegion?
    var reminder: ReminderDataSource?
    var reminderDate: Date?
    var completion: ((String) -> Void)?
    
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
    
    //Sets region of where the user should be notified of reminder
    func setReminderRegion(reminder: ReminderDataSource){
        self.reminder = reminder
        let coordinates = CLLocationCoordinate2D(latitude: reminder.latitude!, longitude: reminder.longitude!)
        self.region = CLCircularRegion(center: coordinates, radius: 400, identifier: reminder.reminderText!)
        locationManager.startMonitoring(for: region!)
        let notification = Notification(reminder: self.reminder!)
        notification.triggerLocationNotification(region: self.region!)
    }
    
    //Sets date for reminder
    func setReminderDate(reminder: ReminderDataSource){
        self.reminder = reminder
        self.reminderDate = reminder.date
        let notification = Notification(reminder: self.reminder!)
        notification.triggerTimeBasedNotifiaction(reminderDate: (self.reminder?.date)!)
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
    //Finds users current location and shares it using location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            self.locationManager.stopUpdatingLocation()
            if locations.first != nil{
                let city = placemarks?[0].addressDictionary?["City"] as! String
                let state = placemarks?[0].addressDictionary?["State"] as! String
                
                self.completion!("Users current location is: \(city), \(state)")
            }
        }
    }
    
    //If there is an error while getting the users location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location \(error.localizedDescription)")
    }
    
    //Begin monitoring users location
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Now monitoring region \(region.identifier)")
    }
    
    //When the user enters a location trigger notifiation to be sent
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("User has entered monitored region")
        let notification = Notification(reminder: self.reminder!)
        notification.triggerLocationNotification(region: self.region!)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("User has left monitored region")
        let notification = Notification(reminder: self.reminder!)
        notification.triggerLocationNotification(region: self.region!)
    }
}
