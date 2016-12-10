//
//  PreferenceTableViewCell.swift
//  Daimler
//
//  Created by Suresh on 01/07/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class PreferenceTableViewCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var selectedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
