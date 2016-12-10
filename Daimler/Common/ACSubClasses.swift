//
//  ACSubClasses.swift
//  Daimler
//
//  Created by Jayavelu R on 28/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class UILabelWithLeftPadding: UILabel {
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}