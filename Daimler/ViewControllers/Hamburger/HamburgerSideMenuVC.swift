//
//  HamburgerSideMenuVC.swift
//  Daimler
//
//  Created by Jayavelu R on 27/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

enum LeftMenu: Int {
    case Main = 0
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class HamburgerSideMenuVC: UIViewController {
    
    @IBOutlet var userName: UILabel!
    var locationVC: LocationVC!
    
    var arrayOfSideMenu: [[String: AnyObject]] = [
        //        [ "title" : "Home",
        //            "icon" : "iconhome"
        //        ],
        [
            "title": "Preferences",
            "icon": "preferences-icon"
        ],
        [
            "title": "Help",
            "icon" : "helpicon"
        ],
        [
            "title": "About",
            "icon" : "about-icon"
        ],
        [
            "title": "Logout",
            "icon": "logout-icon"
        ],
        
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.userName.text = CommonFunctions.getUserName()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfSideMenu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        let cell = tableView.dequeueReusableCellWithIdentifier("HamburgerSideMenuTableViewCell", forIndexPath: indexPath) as! HamburgerSideMenuTableViewCell
        cell.selectionStyle             = .None
        cell.accessoryType              = .None
        tableView.separatorStyle        = .None
        cell.titleLabel.text            = self.arrayOfSideMenu[indexPath.row]["title"] as? String
        cell.sideMenuIcon.image         = UIImage(named: self.arrayOfSideMenu[indexPath.row]["icon"] as! String)
        
        if indexPath.row % 2 == 0
        {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            cell.contentView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard          : UIStoryboard          = UIStoryboard(name: "Main", bundle: nil)
        switch indexPath.row {
            //        case 0:
            //
            //            let menuVC = mainStoryboard.instantiateViewControllerWithIdentifier("TitleViewController") as! TitleViewController
            //            self.presentViewController(menuVC, animated: true, completion: nil)
            
        case 0:
            
            let preferenceVC = mainStoryboard.instantiateViewControllerWithIdentifier("preferenceListVC")
            self.presentViewController(preferenceVC, animated: true, completion: nil)
            
        case 1:
            
            let helpVc = mainStoryboard.instantiateViewControllerWithIdentifier("help_VC")
            
            self.presentViewController(helpVc, animated: true, completion: nil)
            
        case 2:
            
            let aboutVC = mainStoryboard.instantiateViewControllerWithIdentifier("about_VC")
            
            self.presentViewController(aboutVC, animated: true, completion: nil)
            
        case 3:
            
            if let rootVC               : UIViewController =   mainStoryboard.instantiateInitialViewController() as? LoginVC {
                let appDelegate = CommonFunctions.getAppDelegate()
                appDelegate.window!.rootViewController = rootVC
                NSUserDefaults.standardUserDefaults().removeObjectForKey("fullName")
                
            }
        default:
            break
        }
    }
    
    func changeViewController(menu: LeftMenu)
    {
        switch menu
        {
        case .Main:
            
            self.slideMenuController()?.changeMainViewController(self.locationVC, close: true)
            
        default:
            break
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}