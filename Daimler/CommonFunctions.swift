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
    
    class func callToNumber(number : String , viewController : UIViewController)
    {
        if number != "N/A"
        {
            if let encodedUrl = number.encodeUrl()
            {
                if let url = NSURL(string: "tel://\(encodedUrl)")
                {
                    UIApplication.sharedApplication().openURL(url)
                }
                else
                {
                    CommonFunctions.showAlertView("Alert", message: "Unable to make a call to the number \(number)", viewController: viewController)
                }
            }
            else
            {
                CommonFunctions.showAlertView("Alert", message: "Invalid number", viewController: viewController)
            }
        }
        else
        {
            CommonFunctions.showAlertView("Alert", message: "NO number available.", viewController: viewController)
        }
    }
    
    
    class func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
}

extension String
{
    func encodeUrl() -> String?
    {
        return self.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    
}
