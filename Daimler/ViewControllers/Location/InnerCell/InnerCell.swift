//
//  InnerCell.swift
//  Daimler
//
//  Created by Dhandapani R on 12/06/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class InnerCell: UITableViewCell {
    
    @IBOutlet var innerCellValue: UILabel!
    //@IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
