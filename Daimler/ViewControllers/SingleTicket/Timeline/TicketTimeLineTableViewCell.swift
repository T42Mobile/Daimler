//
//  TicketTimeLineTableViewCell.swift
//  Daimler
//
//  Created by Jayavelu R on 29/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class TicketTimeLineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusIndicatorView: UIView!
    @IBOutlet weak var titleLabel   : UILabel!
    @IBOutlet weak var timeLabel    : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        statusIndicatorView.addSurroundingBorder(UIColor.grayColor(), width: 1.0, roundedCorners: true, radius: self.statusIndicatorView.frame.size.width / 2, opacity: 1.0)
        statusIndicatorView.makeRoundedCorners(self.statusIndicatorView.frame.size.width / 2)
        super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
