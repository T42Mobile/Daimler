//
//  CommonFunctions.swift
//  Daimler
//
//  Created by Suresh on 21/06/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class CommonFunctions: NSObject
{
    /**
    Get the image name for the incident type.
     
     - Parameter incidentType : String Incident type
     - Returns String. Image name.
    */
    
    class func getIncidentTypeImageName(incidentType : String) -> String
    {
        var imageName : String = "red-baloon"
        if incidentType == "MAJOR"
        {
            imageName =  "red-baloon"
        }
        else if incidentType == "1"
        {
           imageName = "orange-baloon"
        }
        else if incidentType == "2"
        {
           imageName = "blue-baloon"
        }
        
        return imageName
    }
    
    /**
    Show Alert view with title and message in given viewController
     
     - Parameter title : String? Title for alert view
     - Parameter message : String? Message for alert view
     - Parameter viewController : UIViewController for which alert should be shown
    */
    
    class func showAlertView(title : String?, message : String?, viewController : UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     Show Alert view for no internet condition in given viewController

     - Parameter viewController : UIViewController for which alert should be shown
     */
    
    class func showNoInternetAlertView(viewController : UIViewController)
    {
        showAlertView("Can't connect", message: "Check your internet and try again.", viewController: viewController)
    }
    
    /**
     Show indicator view in givenView
     
     - Parameter view : UIView where in indicator should be shown
     - Parameter isInteractionEnabled : Bool
     */
    
    class func showIndicatorView(view : UIView , isInteractionEnabled : Bool)
    {
        if view.viewWithTag(10000) == nil
        {
            let screenFrame = view.bounds
            let activityView = ActivityView.instanceFromNib()
            activityView.frame = screenFrame
            activityView.setInitiallCondition()
            activityView.tag = 10000
            view.userInteractionEnabled = isInteractionEnabled
            view.addSubview(activityView)
        }
    }
    
    /**
     Hide indicator view in givenView
    */
    
    class func hideIndicatorView(view : UIView)
    {
        if let indicatorView = view.viewWithTag(10000)
        {
            view.userInteractionEnabled = true
            indicatorView.removeFromSuperview()
        }
    }
    
    class func getAppDelegate() -> AppDelegate
    {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    class func getListOfRegionSelected() -> [String]
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let regionArray = userDefaults.objectForKey("regionSelected") as? [String]
        {
            return regionArray
        }
        return []
    }
    
    class func getListOfPrioritySelected() -> [String]
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var priorityList : [String] = []
        if let priorityArray = userDefaults.objectForKey("prioritySelected") as? [String]
        {
            priorityList = priorityArray
        }
        else
        {
            priorityList = ["Major" , "1" , "2"]
            userDefaults.objectForKey("prioritySelected")
        }
        return priorityList
    }
    
    class func convertArrayOfStringIntoString(stringArray : [String]) -> String
    {
        var compoundString : String = ""
        
        for index : Int in 0 ..< stringArray.count
        {
            if index > 0
            {
                compoundString += ","
            }
            compoundString += stringArray[index]
        }
        return compoundString
    }
    
    class func saveRegion(region : String)
    {
        NSUserDefaults.standardUserDefaults().setObject(region, forKey: "regionPreferred")
    }
    
    class func getPreferredRegion() -> String
    {
        if let region = NSUserDefaults.standardUserDefaults().objectForKey("regionPreferred") as? String
        {
            return region
        }
        return ""
    }
    
    class func saveListOfSelectedRegion(selectedRegion : [String])
    {
        NSUserDefaults.standardUserDefaults().setObject(selectedRegion, forKey: "regionSelected")
    }
    
    class func getListOfSelectedRegionName(regionDetailArray : [PreferenceModel]) -> [String]
    {
        var listOfRegionId : [String] = []
        for regionDetail in regionDetailArray
        {
            if regionDetail.isSelected
            {
                listOfRegionId.append(regionDetail.titleText)
            }
        }
        return listOfRegionId
    }
    
    class func getListOfSelectedPriority(regionDetailArray : [PreferenceModel]) -> [String]
    {
        var listOfRegionId : [String] = []
        for regionDetail in regionDetailArray
        {
            if regionDetail.isSelected
            {
                listOfRegionId.append(regionDetail.titleId)
            }
        }
        return listOfRegionId
    }
    
    class func saveListOfSelectedPriority(priorityDetailArray : [PreferenceModel])
    {
        var listOfPriority : [String] = []
        for priorityDetail in priorityDetailArray
        {
            if priorityDetail.isSelected
            {
                listOfPriority.append(priorityDetail.titleId)
                
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(listOfPriority, forKey: "prioritySelected")
    }
    
    class func saveListOfSelectedPriorityFromServer(listOfPriority : [String])
    {
         NSUserDefaults.standardUserDefaults().setObject(listOfPriority, forKey: "prioritySelected")
    }
    
    class func saveSelectedTimeZone(timeZoneString : String)
    {
        NSUserDefaults.standardUserDefaults().setObject(timeZoneString, forKey: "selectedTimeZone")
    }
    
    class func trimNewLineCharacters(stringValue : String?) -> String
    {
        if stringValue == nil
        {
            return ""
        }
        else
        {
            return stringValue!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    class func getUserName() -> String
    {
        if let userName = NSUserDefaults.standardUserDefaults().objectForKey("fullName") as? String
        {
            return userName
        }
        return ""
    }
    
    class func getDeviceToken() -> String
    {
        if let deviceToken = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? String
        {
            return deviceToken
        }
        return ""
    }
}
