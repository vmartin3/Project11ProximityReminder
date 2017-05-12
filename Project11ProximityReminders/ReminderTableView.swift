//
//  ReminderTableView.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/9/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreData

class ReminderTableView: UITableViewController{
    
    var reminderText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataController.sharedInstance.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - Table view data source
extension ReminderTableView {
    
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
                print("Error Setting Post Text")
                return cell
            }
            cell.reminderTextField.text = reminderText
            cell.reminderTextField.isEnabled = false
            cell.moreInfoButton.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            CoreDataController.sharedInstance.context.delete(ReminderDataSource.allReminders[indexPath.row] as NSManagedObject)
            ReminderDataSource.allReminders.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            var error:Error? = nil;
            do{
                try CoreDataController.sharedInstance.context.save()
            }catch{
                print("Unable to save after item deletion")
            }
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sender = sender as! UIButton
        let cell: ReminderCell = sender.superview?.superview as! ReminderCell
        reminderText = cell.reminderTextField.text!
        
        if segue.identifier == "DetailSegue"{
            let detailVC = segue.destination as! LocationDetailTableView
            detailVC.reminderText = reminderText
        }
    }
}

