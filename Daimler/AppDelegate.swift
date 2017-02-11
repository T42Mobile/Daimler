//
//  AppDelegate.swift
//  Daimler
//
//  Created by Jayavelu R on 27/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //self.window!.tintColor = UIColor.whiteColor()
        self.window?.backgroundColor = UIColor.blackColor()
        self.window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UITabBar.appearance().tintColor = GlobalVariables.navigationBarColor()
        
        registerForPushNotifications(application)
        
        let reachability = Reachability.reachabilityForInternetConnection()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkVPNConnection", name: ReachabilityChangedNotification, object: nil)
        reachability?.startNotifier()
        
        if CommonFunctions.getUserName() != ""
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("LocationVC") as! LocationVC
            let leftViewController = storyBoard.instantiateViewControllerWithIdentifier("HamburgerSideMenuVC") as! HamburgerSideMenuVC
            
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
            let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
            slideMenuController.delegate = mainViewController
            self.window?.rootViewController = slideMenuController
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        self.checkVPNConnection()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None
        {
            application.registerForRemoteNotifications()
        }
        else
        {
            self.checkVPNConnection()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        NSUserDefaults.standardUserDefaults().setObject(tokenString, forKey: "deviceToken")
        
       // CommonFunctions.showAlertView("Alert", message : "Device Token:" + tokenString, viewController : self.window!.rootViewController!)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        print("Failed to register:", error)
        
       // CommonFunctions.showAlertView("Alert device token error", message : error.localizedDescription, viewController : self.window!.rootViewController!)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        if let detailDict = userInfo["ticketDetail"] as? NSDictionary
        {
            let applicationState = UIApplication.sharedApplication().applicationState
            
            if applicationState == UIApplicationState.Inactive
            {
                if CommonFunctions.getUserName() != ""
                {
                    let main_Sb = UIStoryboard(name: "Main", bundle: nil)
                    //                    let rootViewController = main_Sb.instantiateViewControllerWithIdentifier("TitleViewController") as! TitleViewController
                    //                    self.window?.rootViewController = rootViewController
                    //                    let titleDetailVc = main_Sb.instantiateViewControllerWithIdentifier("titleDetail_VC")
                    //
                    //                    rootViewController.presentViewController(titleDetailVc, animated: false, completion: nil)
                    
                    
                    let mainViewController = main_Sb.instantiateViewControllerWithIdentifier("LocationVC") as! LocationVC
                    let leftViewController = main_Sb.instantiateViewControllerWithIdentifier("HamburgerSideMenuVC") as! HamburgerSideMenuVC
                    
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                    
                    let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                    slideMenuController.delegate = mainViewController
                    
                    self.window?.rootViewController = slideMenuController
                    
                    //titleDetailVc.presentViewController(slideMenuController, animated: false, completion: nil)
                    let time = main_Sb.instantiateViewControllerWithIdentifier("push1")as! TimelineViewController
                    time.incidentDetail = IncidentDetailModel.init(dictionary: detailDict)
                    nvc.pushViewController(time, animated: true)
                    
                }
                
            }
        }
    }
    
    func checkVPNConnection()
    {
        if ServiceHelper.checkInternetConnection()
        {
            if !CommonFunctions.getIFAddresses().contains(ServiceHelper.getDomainUrl())
            {
                let alert = UIAlertController(title: "VPN settings", message: "Please turn on your VPN connection.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:nil))
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: {
                    (alert: UIAlertAction!) in
                    
                    let osVersion = (UIDevice.currentDevice().systemVersion as NSString).doubleValue
                    let url : NSURL!
                    if osVersion >= 10.0
                    {
                        url = NSURL(string: "App-Prefs:root=General&path=Network/VPN")!
                    }
                    else
                    {
                        url = NSURL(string:"prefs:root=General&path=Network/VPN")!
                    }
                    UIApplication.sharedApplication().openURL(url)
                }))
                self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}

