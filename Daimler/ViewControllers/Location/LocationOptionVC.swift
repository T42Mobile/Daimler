//
//  LocationOptionVC.swift
//  Daimler
//
//  Created by Developer on 29/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class LocationOptionVC: UIViewController {
    

    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func actionLocateCurrentLocation(sender: AnyObject) {
        
        let mainViewController = storyboard?.instantiateViewControllerWithIdentifier("LocationVC") as! LocationVC
        let leftViewController = storyboard?.instantiateViewControllerWithIdentifier("HamburgerSideMenuVC") as! HamburgerSideMenuVC
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.presentViewController(slideMenuController, animated: true) {
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}
