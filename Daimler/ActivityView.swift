//
//  ActivityView.swift
//  Daimler
//
//  Created by Suresh on 23/06/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class ActivityView: UIView {

    @IBOutlet var borderView: UIView!
    @IBOutlet var activityTextLbl: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
      func setInitiallCondition() {
        self.borderView.layer.cornerRadius = 5.0
        self.borderView.layer.borderWidth = 5.0
        self.borderView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.borderView.layer.masksToBounds = true
    }
    
    class func instanceFromNib() -> ActivityView {
        return UINib(nibName: "ActivityView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ActivityView
    }
    
    func setLabelText(text : String)
    {
        activityTextLbl.text = text
    }
}
