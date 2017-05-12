//
//  LocationDetailTableView.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/9/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailTableView: UITableViewController {
    
    var reminder: ReminderDataSource = ReminderDataSource()
    
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var dateSwitch: UISwitch!
    
    @IBOutlet weak var reminderTextField: UITextField!
    var reminderText: String?
  
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    
    var location: MKMapItem?
    var locationText:String = "Locations"
    var locationisSet: Bool = false

    var date: Date?
    var completed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationisSet == true {
           locationSwitch.isOn = true
            locationCell.isHidden = false
            dateCell.isHidden = true
            datePickerView.isHidden = true
            
            var message = ShowAlert(title: "Reminder Location Set", message: "You will be reminded when you get near \(locationText)", action: "Okay")
            self.present(message.showAlert(title: message.title, message: message.message, action: message.action), animated: true)
            
        } else {
        dateSwitch.isOn = false
        locationSwitch.isOn = false
        locationCell.isHidden = true
        dateCell.isHidden = true
        datePickerView.isHidden = true
        }
        
        dateSwitch.addTarget(self, action: #selector(LocationDetailTableView.setDateState), for: .valueChanged)
        locationSwitch.addTarget(self, action: #selector(LocationDetailTableView.setLocationState), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(LocationDetailTableView.dateChanged), for: .valueChanged)
        
        locationTextLabel.text = locationText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //When reminder details are set, this button tap will save the reminder to core data and return to home page
    @IBAction func donePressed(_ sender: Any) {
        reminderText = reminderTextField.text
        
        CoreDataController.sharedInstance.save(reminderText: self.reminderText!, date: self.date!, longitude: (self.location?.placemark.coordinate.longitude)!, latitude: (self.location?.placemark.coordinate.latitude)!, completed: false)
        
        let mainPage = self.navigationController?.viewControllers[0] as! ReminderTableView
        mainPage.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func setDateState(sender: UISwitch){
        if sender.isOn {
            dateCell.isHidden = false
            datePickerView.isHidden = false
        } else {
            dateCell.isHidden = true
            datePickerView.isHidden = true
        }
    }
    
    func setLocationState(sender: UISwitch){
        if sender.isOn {
            locationCell.isHidden = false
        } else {
            locationCell.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let view = cell.contentView.subviews.first
        if indexPath.section == 0 && indexPath.section == 0 {
                reminderTextField = view as? UITextField
                reminderTextField.text = reminderText
            }
        }
    
    @IBAction func unwindToDetail(segue: UIStoryboardSegue) {
        //self.navigationController?.viewDidLoad()
        self.tableView.reloadData()
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.locationTextLabel.text = self.locationText
        }
    }
}

