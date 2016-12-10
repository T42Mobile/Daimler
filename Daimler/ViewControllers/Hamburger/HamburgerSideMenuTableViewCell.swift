//
//  HamburgerSideMenuTableViewCell.swift
//  Daimler
//
//  Created by Jayavelu R on 29/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class HamburgerSideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sideMenuIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}