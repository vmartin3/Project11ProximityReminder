//
//  ReminderCell.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/9/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var reminderTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        reminderTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)! {
            moreInfoButton.isHidden = true
        }else{
            moreInfoButton.isHidden = false
        }
    }

}
