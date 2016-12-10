//
//  ACGlobalVariables.swift
//  Daimler
//
//  Created by Jayavelu R on 28/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class GlobalVariables: NSObject {
    
    class func navigationBarColor() -> UIColor {
        return UIColor.darkTextColor()
    }
    
    class func indicatorBlueColor() -> UIColor {
        return UIColor(hexString: "209ACB")
    }
    
    class func indicatorGrayColor() -> UIColor {
        return UIColor(hexString: "D3D3D3", alpha: 0.8)
    }
    
    class func indicatorDefaultColor() -> UIColor {
        return UIColor.darkTextColor()
    }
}