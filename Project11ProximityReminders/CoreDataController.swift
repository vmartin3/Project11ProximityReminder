//
//  CoreDataController.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/10/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSManagedObject {
    static let sharedInstance = CoreDataController()
    
    //All keys for the Reminder Entity
    enum ReminderKeys:String {
        case longitude = "longitude"
        case latitude = "latitude"
        case date = "date"
        case reminderText = "reminderText"
        case completed = "completed"
    }
    
    //Returns managedObjectContext
    var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        return managedContext!
    }()
    
    //Attempts to save reminder details using information that is passed in
    func save(reminderText: String, date: Date, longitude: Double, latitude: Double, completed: Bool) {
        let reminder = NSEntityDescription.insertNewObject(forEntityName: Reminder.identifier, into: context) as! Reminder
        reminder.setValue(reminderText, forKey: ReminderKeys .reminderText.rawValue)
        reminder.setValue(date, forKey: ReminderKeys .date.rawValue)
        reminder.setValue(longitude, forKey: ReminderKeys .longitude.rawValue)
        reminder.setValue(latitude, forKey: ReminderKeys .latitude.rawValue)
        reminder.setValue(completed, forKey: ReminderKeys .completed.rawValue)
        
        do {
            try context.save()
            ReminderDataSource.allReminders.append(reminder)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteReminder(reminderObject: NSManagedObject, reminderNumber: Int){
        do{
            context.delete(reminderObject)
            ReminderDataSource.allReminders.remove(at: reminderNumber)
            try context.save()
        } catch let error as NSError {
            print("Could not delete remidner \(error)")
        }
    }
    
    //Attempts to fetch all reminders from core data, assigns it to the arrary of all reminders
    func fetch(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        do {
            ReminderDataSource.allReminders = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //Update and Edits the text of a perviously saved entry
//    func updatePost(index: Int, newPost: String){
//        DiaryTableView.diaryPosts[index].setValue(newPost, forKey: DiaryKeys .post.rawValue)
//        do{
//            try managedObjectContext.save()
//        } catch let error as NSError{
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//        
//    }
}
