//
//  LocationCell.swift
//  Project11ProximityReminders
//
//  Created by Vernon G Martin on 5/13/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
