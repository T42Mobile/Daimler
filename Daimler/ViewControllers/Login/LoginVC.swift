//
//  LoginVC.swift
//  Daimler
//
//  Created by Jayavelu R on 27/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController,NSXMLParserDelegate
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var url: NSString = ""
    var selfViewMoveValue: CGFloat = 200
    
    override func viewDidLoad()
    {
        var appDefaults = Dictionary<String, AnyObject>()
        appDefaults["domain_Url"] = domainUrl
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.passwordTextField.secureTextEntry = true
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string:"User Name",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        //MARK: - Add swipe down gesture resign the keyboard and move down the view
        let swipeDownToResignKeyboard: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"dismissKeyboard")
        swipeDownToResignKeyboard.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDownToResignKeyboard)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func showAlert()
    {
        let alertController = UIAlertController(title: "Alert", message: "Server could not be connected, please check your VPN connection and then try again.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAuthenticationAlert()
    {
        let alertController = UIAlertController(title: "Alert", message: "Please check your credentials and try again.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showSettingsAlert()
    {
        let alertController = UIAlertController(title: "Change Settings", message: "Enter Values in Bundle settings", preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        //let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func actionLogin(sender: AnyObject)
    {
        if usernameTextField == "trigchn\\aishwarya" && passwordTextField == "trig@123"
        {
            self.performSegueWithIdentifier("self", sender: sender)
        }
        self.menuView()
        //self.getUserPreferences()
    }
    
    @IBAction func Login(sender: AnyObject)
    {
        self.dismissKeyboard()
        if usernameTextField.text == "" && passwordTextField.text == ""
        {
            self.showAuthenticationAlert()
        }
        else
        {
            self.authenticate()
        }
    }
    
    func authenticate() {
        
        let window = CommonFunctions.getAppDelegate().window!
        CommonFunctions.showIndicatorView(window, isInteractionEnabled: false)
        ServiceHelper.checkLoginDetail(usernameTextField.text!, password: passwordTextField.text!) { (loginDetail, error ) -> Void in
            CommonFunctions.hideIndicatorView(window)
            if error != nil
            {
                if error?.code != 101
                {
                    CommonFunctions.showAlertView("Alert", message: error?.localizedDescription, viewController: self)
                }
                else
                {
                    CommonFunctions.showNoInternetAlertView(self)
                }
            }
            else
            {
                print(loginDetail)
                if let loginDetail = (loginDetail?.objectForKey("ArrayOfRetValid") as? NSDictionary)?.objectForKey("RetValid") as? NSDictionary
                {
                    if let status = loginDetail.objectForKey("MESSAGE") as? String
                    {
                        if status == "200"
                        {
                            self.saveUserPreference(loginDetail)
                            let fullName = CommonFunctions.trimNewLineCharacters(self.usernameTextField.text)
                            NSUserDefaults.standardUserDefaults().setObject(fullName, forKey: "fullName")
                            self.menuView()
                        }
                        else
                        {
                            if let statusMessage =  loginDetail.objectForKey("STATUSMESSAGE") as? String
                            {
                                CommonFunctions.showAlertView("Alert", message : statusMessage, viewController : self)
                            }
                            else
                            {
                                self.showAuthenticationAlert()
                            }
                        }
                    }
                    else
                    {
                        self.showAlert()
                    }
                }
                else
                {
                    self.showAlert()
                }
            }
        }
    }
    
    func getUserPreferences()
    {
        let window = CommonFunctions.getAppDelegate().window!
        CommonFunctions.showIndicatorView(window, isInteractionEnabled: false)
        ServiceHelper.getUserPreferences { (detailDict, error ) -> Void in
            CommonFunctions.hideIndicatorView(window)
            
            if let preferenceDetail = (detailDict?.objectForKey("ArrayOfRetPreferences") as? NSDictionary)?.objectForKey("RetPreferences") as? NSDictionary
            {
                self.saveUserPreference(preferenceDetail)
            }
        }
    }
    
    func menuView(){
        
        let mainViewController = storyboard?.instantiateViewControllerWithIdentifier("LocationVC") as! LocationVC
        let leftViewController = storyboard?.instantiateViewControllerWithIdentifier("HamburgerSideMenuVC") as! HamburgerSideMenuVC
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.presentViewController(slideMenuController, animated: true ,  completion: nil)
        
        
        //        let menuVC = storyboard?.instantiateViewControllerWithIdentifier("TitleViewController") as! TitleViewController
        //
        //        self.presentViewController(menuVC, animated: true, completion: nil)
        //
    }
    
    func openSettings(){
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    // Textfields delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        dismissKeyboard()
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //showKeyBoard()
        // self.view.animateAndMoveUpOrDown(true, moveValue: selfViewMoveValue)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //self.view.endEditing(true)
        //dismissKeyboard()
        //self.view.animateAndMoveUpOrDown(false, moveValue: selfViewMoveValue)
    }
    
    // Dismiss the keyboard while swipe down
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showKeyBoard() {
        if self.view.frame.origin.y   == 0 {
            self.view.animateAndMoveUpOrDown(true, moveValue: selfViewMoveValue)
        }
    }
    
    func saveUserPreference(preferenceDetail : NSDictionary)
    {
        var  selectedPriorities = CommonFunctions.trimNewLineCharacters(preferenceDetail.objectForKey("PRIORITIES") as? String)
        var selectedRegion = CommonFunctions.trimNewLineCharacters(preferenceDetail.objectForKey("REGIONS") as? String)
        let selectedtimeZone = CommonFunctions.trimNewLineCharacters(preferenceDetail.objectForKey("TIMEZONE") as? String)
        
        if selectedPriorities == "N/A"
        {
            selectedPriorities = ""
        }
        if selectedRegion == "N/A"
        {
            selectedRegion = ""
        }
        if selectedtimeZone != "N/A"
        {
            CommonFunctions.saveSelectedTimeZone(selectedtimeZone)
        }
        
        CommonFunctions.saveListOfSelectedPriorityFromServer(selectedPriorities.componentsSeparatedByString(","))
       // CommonFunctions.saveListOfSelectedRegion(selectedRegion.componentsSeparatedByString(","))
        CommonFunctions.saveRegion(selectedRegion)
    }
    
    func keyBoardWillShow(notification : NSNotification)
    {
        let keyBoardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        selfViewMoveValue = keyBoardFrame.height
        showKeyBoard()
    }
    
    func keyBoardWillHide()
    {
        if self.view.frame.origin.y  != 0 {
            self.view.animateAndMoveUpOrDown(false, moveValue: selfViewMoveValue)
        }
    }
}