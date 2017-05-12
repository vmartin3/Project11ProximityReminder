//
//  DatePickerHelper.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/12/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import Foundation

struct DatePicker{
    func dateChanged(sender: UIDatePicker){
        let date = sender.date
        dateTextLabel.text = "Remind me on: \(date)"
        self.date = date
    }
    
}
