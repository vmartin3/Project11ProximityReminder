//
//  Reminder.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/10/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreData


class Reminder: NSManagedObject {
    static let identifier = "Reminder"
}

extension Reminder {
    @NSManaged var longitude: Double
    @NSManaged var latitude: Double
    @NSManaged var date: Date
    @NSManaged var reminderText: String
    @NSManaged var completed: Bool
}
