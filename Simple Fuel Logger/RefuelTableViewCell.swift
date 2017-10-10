//
//  RefuelTableViewCell.swift
//  Simple Fuel Logger
//
//  Created by Master on 06/10/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit

class RefuelTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tankImageView: UIImageView!
    @IBOutlet weak var efficiencyMeter: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("Cell awake from nib")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
