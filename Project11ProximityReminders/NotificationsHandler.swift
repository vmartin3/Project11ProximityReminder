//
//  File.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/12/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreLocation

class Notification: NSObject {
    //let content = UNMutableNotificationContent()
    
    var reminder:ReminderDataSource
    var reminderCoordinate: CLLocationCoordinate2D?
    var region: CLCircularRegion?
    
    init(reminder: ReminderDataSource){
        self.reminder = reminder
    }
    
    
    func triggerLocationNotification(region: CLCircularRegion){
        print("Location Notification Triggered")
        
        let content = UNMutableNotificationContent()
        //reminderCoordinate = CLLocationCoordinate2DMake(reminder.latitude!, reminder.longitude!)
       self.region = region
        content.title = "Reminder App"
        content.body = reminder.reminderText!
        content.badge = 1
        content.sound = UNNotificationSound.default()
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region:region, repeats:false)
        let request = UNNotificationRequest(identifier:reminder.reminderText!, content: content, trigger: trigger)

         UNUserNotificationCenter.current().add(request)
    }
    
    func triggerTimeBasedNotifiaction(reminderDate: Date){
        let content = UNMutableNotificationContent()
        content.title = "Reminder App"
        content.body = reminder.reminderText!
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let componenets = Calendar.current.dateComponents([.month, .day, .hour, .minute,. year], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: componenets, repeats: false)
        let request = UNNotificationRequest(identifier:reminder.reminderText!, content: content, trigger: trigger)
        
         UNUserNotificationCenter.current().add(request) { (error) in
            if (error != nil){
            print("ERRROR: \(error.debugDescription))")
            }
        }
    }
    
}
