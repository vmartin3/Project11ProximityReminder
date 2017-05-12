//
//  CreateUIAlertMessage.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/12/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import Foundation
import  UIKit

struct ShowAlert{
    var title: String
    var message: String
    var action: String
    
    func showAlert(title:String, message:String, action:String) -> UIAlertController{
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        return alert
    }
    
}


