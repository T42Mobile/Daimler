//
//  DetailsTableViewCell.swift
//  Daimler
//
//  Created by admin on 12/06/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel:UILabel?
    @IBOutlet weak var detailsLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
