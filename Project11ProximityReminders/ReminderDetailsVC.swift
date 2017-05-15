//
//  ReminderDetailsVC.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/9/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class ReminderDetailsVC: UITableViewController {
    
    var reminder: ReminderDataSource = ReminderDataSource()
    
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var dateSwitch: UISwitch!
    
    @IBOutlet weak var reminderTextField: UITextField!
  
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    
    var locationText:String = "Select Location"
    var locationisSet: Bool = false
    var completed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView(){
        dateSwitch.isOn = false
        locationSwitch.isOn = false
        locationCell.isHidden = true
        dateCell.isHidden = true
        datePickerView.isHidden = true
        
        dateSwitch.addTarget(self, action: #selector(ReminderDetailsVC.setDateState), for: .valueChanged)
        locationSwitch.addTarget(self, action: #selector(ReminderDetailsVC.setLocationState), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(ReminderDetailsVC.dateChanged), for: .valueChanged)
        
        locationTextLabel.text = locationText
    }
    
    //Date UI Switch Settings
    func setDateState(sender: UISwitch){
        if sender.isOn {
            dateCell.isHidden = false
            datePickerView.isHidden = false
            locationCell.isHidden = true
            locationSwitch.isOn = false
        } else {
            dateCell.isHidden = true
            datePickerView.isHidden = true
        }
    }
    
    //Location UI Switch Settings
    func setLocationState(sender: UISwitch){
        if sender.isOn {
            locationCell.isHidden = false
            dateSwitch.isOn = false
            dateCell.isHidden = true
            datePickerView.isHidden = true
        } else {
            locationCell.isHidden = true
        }
    }
    
    //Return to main page
    func popViewController(){
        let mainPage = self.navigationController?.viewControllers[0] as! RemindersTableVC
        mainPage.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkForNilValues(){
        if reminder.latitude == nil  {
            reminder.latitude = 0.0
        }
        if reminder.longitude == nil {
            reminder.longitude = 0.0
        }
        if reminder.date == nil {
            reminder.date = Date()
        }
    }
    
    //When reminder details are set, this button tap will save the reminder to core data and return to home page
    @IBAction func donePressed(_ sender: Any) {
        reminder.reminderText = reminderTextField.text
        reminder.completed = completed
        
        checkForNilValues()
        
        if reminder.reminderText == nil || reminder.reminderText == ""{
            let alert = UIAlertController(title: "No Reminder Text Found", message: "We can't save a blank reminder, enter some text please", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            reminder.reminderText = reminderTextField.text
        } else {
        
        CoreDataController.sharedInstance.save(reminderText: reminder.reminderText!, date: reminder.date!, longitude: reminder.longitude!, latitude: reminder.latitude!, completed: reminder.completed!)
        
        if locationSwitch.isOn {
            LocationManager.sharedLocationInstance.setReminderRegion(reminder: reminder)
        } else {
            LocationManager.sharedLocationInstance.setReminderDate(reminder: reminder)
        }
            
        popViewController()
    }
}
    
    @IBAction func unwindToDetail(segue: UIStoryboardSegue) {
        self.locationTextLabel.text = self.locationText
    }
}


extension ReminderDetailsVC {
    //UIDate Picker Helper
    func dateChanged(sender: UIDatePicker){
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d @ hh:mm a"
        let fullDate = formatter.string(from: date)
        dateTextLabel.text = "Remind me on: \(fullDate)"
        reminder.date = date
    }
    
    //Sets the UIReminder Text Label with the input from what was entered on the mainpage
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let view = cell.contentView.subviews.first
        if indexPath.section == 0 && indexPath.section == 0 {
            reminderTextField = view as? UITextField
            reminderTextField.text = reminder.reminderText 
        }
    }
}

