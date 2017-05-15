//
//  RemindersTableVC.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/9/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreData

class RemindersTableVC: UITableViewController{
    
    var reminderText:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataController.sharedInstance.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - UITableView extenstion to get last row
extension UITableView {
    
    var lastIndexPath: IndexPath? {
        
        let lastSectionIndex = numberOfSections - 1
        guard lastSectionIndex >= 0 else { return nil }
        
        let lastIndexInLastSection = numberOfRows(inSection: lastSectionIndex) - 1
        guard lastIndexInLastSection >= 0 else { return nil }
        
        return IndexPath(row: lastIndexInLastSection, section: lastSectionIndex)
    }
}


// MARK: - Table view data source
extension RemindersTableVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderDataSource.allReminders.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        
        if !ReminderDataSource.allReminders.isEmpty && indexPath.row < ReminderDataSource.allReminders.count{
            guard let reminderText = ReminderDataSource.allReminders[indexPath.row].value(forKey: "reminderText") as? String else {
                print("Error Setting Reminder Details")
                return cell
            }
            cell.reminderTextField.text = reminderText
            cell.reminderTextField.isEnabled = false
            cell.moreInfoButton.isHidden = true
        }
        return cell
    }
    
    //Makes the last row - where the reminder entry cell is non deletable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row == tableView.lastIndexPath?.row){
            return false
        }else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
                CoreDataController.sharedInstance.deleteReminder(reminderObject: ReminderDataSource.allReminders[indexPath.row] as NSManagedObject, reminderNumber: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: - Navigation
    //Pass reminder details to the next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sender = sender as! UIButton
        let cell: ReminderCell = sender.superview?.superview as! ReminderCell
        reminderText = cell.reminderTextField.text!
        
        if segue.identifier == "DetailSegue"{
            let detailVC = segue.destination as! ReminderDetailsVC
            detailVC.reminder.reminderText = reminderText!
        }
    }
}

