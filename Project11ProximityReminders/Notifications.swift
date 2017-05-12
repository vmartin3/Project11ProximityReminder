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

class Notification: NSObject, UNUserNotificationCenterDelegate {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let requestIdentifier = "VGMnotificationIdentifier"
    
    func triggerNotification(){
        print("Notification Triggered")
        let content = UNMutableNotificationContent()
        content.title = "Reminder App"
        content.body = "This is a reminder to buy milk"
        content.sound = UNNotificationSound.default()
        
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2.0, repeats: false)
        let region = CLCircularRegion(center: <#T##CLLocationCoordinate2D#>, radius: <#T##CLLocationDistance#>, identifier: "Test Location")
        let trigger = UNLocationNotificationTrigger(triggerWithRegion:region, repeats:false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

extension Notification {

        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            print("Tapped in notification")
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,   notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            print("Notification being triggered")
            //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
            //to distinguish between notifications
            if notification.request.identifier == requestIdentifier{
                
                completionHandler( [.alert,.sound,.badge])
                
            }
        }
    }
