//
//  MenuVC.swift
//  Daimler
//
//  Created by Jayavelu R on 06/06/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class MenuVC: UIViewController {
    
    var locationOptionVC    : LocationOptionVC!
    
    @IBAction func locateNow(sender: AnyObject) {
        //        self.presentViewController(self.locationOptionVC, animated: true) {
        //        }
        
        let mainViewController = storyboard?.instantiateViewControllerWithIdentifier("LocationVC") as! LocationVC
        let leftViewController = storyboard?.instantiateViewControllerWithIdentifier("HamburgerSideMenuVC") as! HamburgerSideMenuVC
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.presentViewController(slideMenuController, animated: true)
            {
                
        }
    }
    
    override func viewDidLoad() {
        self.locationOptionVC     = storyboard?.instantiateViewControllerWithIdentifier("LocationOptionVC") as! LocationOptionVC
    }
}