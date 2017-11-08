//
//  ViewControllerTableViewCell.swift
//  SwiftCM
//
//  Created by Logan on 08.10.17.
//  Copyright © 2017 Logan. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var timeFrameLabel: UILabel!
    @IBOutlet weak var strongestLabel: UILabel!
    @IBOutlet weak var weakestLabel: UILabel!
    @IBOutlet weak var strongWeakPairLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
