//
//  ReminderDataSource.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/10/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import Foundation
import CoreData

class ReminderDataSource {
    
    static var allReminders: [NSManagedObject] = []
    
    var longitude: Double?
    var latitude: Double?
    var date: Date?
    var reminderText: String?
    var completed: Bool?
    
    var reminderDetailTable: LocationDetailTableView?
    
//    init(longitude: Double, latitude: Double, date: Date, reminderText:String,completed:Bool) {
//        self.longitude = longitude
//        self.latitude = latitude
//        self.date = date
//        self.reminderText = reminderText
//        self.completed = completed
//    }
    

    

}
