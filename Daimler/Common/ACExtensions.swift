//
//  ACExtensions.swift
//  Daimler
//
//  Created by Jayavelu R on 28/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        if let slide = viewController as? SlideMenuController {
            return topViewController(slide.mainViewController)
        }
        return viewController
    }
}

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "hamburger-menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
}

extension UINavigationController {
    // MARK -  Any action can be done in the completion cycle after the navigation PUSH completed
    func pushViewController(viewController: UIViewController, animated: Bool, completion: Void -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

extension UIView {
    // Animate the view while it shows
    func animateWhenShow() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.alpha  = 1.0
            }, completion: { (Bool) -> Void in
        })
    }
    // Animate the view while it hides
    func animateWhenHide() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.alpha  = 0.0
            }, completion: { (Bool) -> Void in
        })
    }
    // Animate the view while it moves up or down
    func animateAndMoveUpOrDown(up: Bool, moveValue: CGFloat) {
        
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        // Animation
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.frame = CGRectOffset(self.frame, 0,  movement)
        UIView.commitAnimations()
    }
    /*
     -This method will draw the border for particular side based on the user input 'spec'
     -'spec' can be - ["top": 1.0, "bottom": 1.0, "left": 1.0, "right": 1.0]
     */
    func addBorder(color: UIColor, spec: [String: Float]) {
        for (key, value) in spec {
            let border                  = CALayer()
            border.borderColor          = color.CGColor
            if spec["opacity"] != nil {
                border.opacity  = spec["opacity"]!
            }
            let width                   = CGFloat(value)
            switch key {
            case "top":
                border.frame            = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            case "left":
                border.frame            = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            case "right":
                border.frame            = CGRect(x: (self.frame.size.width - width), y: 0 , width: width, height: self.frame.size.height)
            case "center":
                border.frame            = CGRect(x: 0, y: (self.center.y - (width / 2)), width: self.frame.size.width, height: width)
            default:
                border.frame            = CGRect(x: 0, y: (self.frame.size.height - width), width: self.frame.size.width, height: width)
            }
            border.borderWidth          = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds  = true
        }
    }
    // Add surrounding border
    func addSurroundingBorder(color: UIColor, width: CGFloat, roundedCorners: Bool, radius: CGFloat, opacity: Float) {
        let border                    = CALayer()
        border.frame                  = self.bounds
        border.borderColor            = color.CGColor
        border.opacity                = opacity
        border.borderWidth            = width
        if roundedCorners {
            border.cornerRadius       = radius
            self.clipsToBounds        = true
        }
        self.layer.masksToBounds    = true
        self.layer.addSublayer(border)
    }
    // Make rounded corners
    func makeRoundedCorners(radius: CGFloat) {
        self.layer.cornerRadius     = radius
        self.layer.masksToBounds    = true
        self.clipsToBounds          = true
    }
    // Add background color for a view with custom opacity
    func addBackgroundColor(color: UIColor, opacity: Float) -> CALayer {
        let backgroundColor             = CALayer()
        backgroundColor.frame           = CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height)
        backgroundColor.backgroundColor = color.CGColor
        backgroundColor.opacity         = opacity
        self.layer.insertSublayer(backgroundColor, atIndex: 0)
        self.layer.masksToBounds      = true
        return backgroundColor
    }
}

extension UIColor {
    // Creates a UIColor from a Hex string.
    convenience init(hexString: String) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substringToIndex(2)
            let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
            let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)
            
            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
    }
    
    convenience init(hexString: String, alpha: CGFloat) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substringToIndex(2)
            let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
            let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)
            
            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: alpha)
        }
    }
}