//
//  ServiceHelper.swift
//  Daimler
//
//  Created by Suresh on 21/06/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

//let domainUrl : String = "10.10.10.10:1236"
let domainUrl : String = "53.244.194.68:100"
//let domainUrl : String = "192.168.2.3:100"


class ServiceHelper: NSObject {

    class func getListOfLocations(ticketType : String ,completionHandler : (NSDictionary? , NSError?) -> Void?)
    {
        if checkInternetConnection()
        {
            let request = NSMutableURLRequest(URL: NSURL(string:"http://\(self.getDomainUrl())/WS_GetIncidentDetails.asmx/getTicketLocDetails")!)
            request.HTTPMethod = "POST"
            
            let selectedPriority = CommonFunctions.convertArrayOfStringIntoString(CommonFunctions.getListOfPrioritySelected())
            
//            var selectedRegion = CommonFunctions.getListOfRegionSelected()
//            
//            if selectedRegion.count == 0
//            {
//                selectedRegion.append("All")
//            }
//            let selectedRegionString = CommonFunctions.convertArrayOfStringIntoString(selectedRegion)
            let selectedRegionString = CommonFunctions.getPreferredRegion()
            
            let postString = "location=\(selectedRegionString)&priority=\(selectedPriority)&Ticket_Type=\(ticketType)"
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard error == nil && data != nil else {                                                          // check for fundamental
                        
                        completionHandler(nil,error)
                        return
                    }
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        completionHandler(nil, createLocalError())
                    }
                    XMLConverter.convertXMLData(data!, completion: { (success, dictionary, error) -> Void in
                        if success
                        {
                            completionHandler(dictionary,nil)
                        }
                        else
                        {
                            completionHandler(nil, createLocalError())
                        }
                    })
                    
                })
            }
            task.resume()
        }
        else
        {
            completionHandler(nil, createNoInternetError())
        }
    }
    
    class func checkLoginDetail(userName : String , password : String , completionHandler : (NSDictionary? , NSError?) -> Void?)
    {
        if checkInternetConnection()
        {
            let request = NSMutableURLRequest(URL: NSURL(string:"http://\(self.getDomainUrl())/WS_GetIncidentDetails.asmx/validateCredentials")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
            request.HTTPMethod = "POST"
            
//            let deviceToken = CommonFunctions.getDeviceToken()
//            let postString = "username=\(userName)&password=\(password)&DeviceID=\(deviceToken)"
//            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let deviceToken = CommonFunctions.getDeviceToken()
            
            let encryptObj = StringEncryption()
            let key = encryptObj.sha256("password", length: 32)
            let iv = encryptObj.generateRandomIV(16)
            
            let encrptedUserName = encryptObj.encrypt(userName.dataUsingEncoding(NSUTF8StringEncoding), key: key, iv:iv)
            let encryptedUserNameString = encrptedUserName.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            let encrptedPassword = encryptObj.encrypt(password.dataUsingEncoding(NSUTF8StringEncoding), key: key, iv:iv)
            let encryptedPasswordString = encrptedPassword.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            let postString = "usernam=\(encryptedUserNameString)&passwd=\(encryptedPasswordString)&iv=\(iv)&DeviceID=\(deviceToken)"
            let replacedData = postString.stringByReplacingOccurrencesOfString("+", withString: "*")
            let replace = replacedData.stringByReplacingOccurrencesOfString("/", withString: "@")
            request.HTTPBody = replace.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard error == nil && data != nil else {                                                          // check for fundamental
                        completionHandler(nil,error)
                        return
                    }
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        completionHandler(nil, createLocalError())
                    }
                    
                    XMLConverter.convertXMLData(data!, completion: { (success, dictionary, error) -> Void in
                        if success
                        {
                            completionHandler(dictionary,nil)
                        }
                        else
                        {
                            completionHandler(nil, createLocalError())
                        }
                    })
                })
            }
            task.resume()
        }
        else
        {
            completionHandler(nil, createNoInternetError())
        }
    }

    
    class func getIncidentCount(completionHandler : (NSDictionary? , NSError?) -> Void?)
    {
        if checkInternetConnection()
        {
            let request = NSMutableURLRequest(URL: NSURL(string:"http://\(self.getDomainUrl())/WS_GetIncidentDetails.asmx/getIncidentCount")!)
            request.HTTPMethod = "POST"
            let postString = "location=ALL"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard error == nil && data != nil else {                                                          // check for fundamental
                        completionHandler(nil,error)
                        return
                    }
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        completionHandler(nil, createLocalError())
                    }
                    XMLConverter.convertXMLData(data!, completion: { (success, dictionary, error) -> Void in
                        if success
                        {
                            completionHandler(dictionary,nil)
                        }
                        else
                        {
                            completionHandler(nil, createLocalError())
                        }
                    })
                })
            }
            task.resume()
        }
        else
        {
            completionHandler(nil, createNoInternetError())
        }
    }
    
    class func getRegions(completionHandler : (NSDictionary? , NSError?) -> Void?)
    {
        if checkInternetConnection()
        {
            let request = NSMutableURLRequest(URL: NSURL(string:"http://\(self.getDomainUrl())/WS_GetIncidentDetails.asmx/getRegions")!)
            request.HTTPMethod = "POST"
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard error == nil && data != nil else {                                                          // check for fundamental
                        completionHandler(nil,error)
                        return
                    }
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        completionHandler(nil, createLocalError())
                    }
                    XMLConverter.convertXMLData(data!, completion: { (success, dictionary, error) -> Void in
                        if success
                        {
                            completionHandler(dictionary,nil)
                        }
                        else
                        {
                            completionHandler(nil, createLocalError())
                        }
                    })
                })
            }
            task.resume()
        }
        else
        {
            completionHandler(nil, createNoInternetError())
        }
    }
    
    class func savePreferences(postString : String , completionHandler : (NSDictionary? , NSError?) -> Void?)
    {
        if checkInternetConnection()
        {
            let request = NSMutableURLRequest(URL: NSURL(string:"http://\(self.getDomainUrl())/WS_GetIncidentDetails.asmx/saveuserpreferences")!)
            request.HTTPMethod = "POST"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard error == nil && data != nil else {                                                          // check for fundamental
                        completionHandler(nil,error)
                        return
                    }
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        completionHandler(nil, createLocalError())
                    }
                    XMLConverter.convertXMLData(data!, completion: { (success, dictionary, error) -> Void in
                        if success
                        {
                            completionHandler(dictionary,nil)
                        }
                        else
                        {
                            completionHandler(nil, createLocalError())
                        }
                    })
                })
            }
            task.resume()
        }
        else
        {
            completionHandler(nil, createNoInternetError())
        }
    }
    
    class func getUserPreferences(completionHandler : (NSDictionary? , NSError?) -> Void?)
    {
        if checkInternetConnection()
        {
            let request = NSMutableURLRequest(URL: NSURL(string:"http://\(self.getDomainUrl())/WS_GetIncidentDetails.asmx/getuserpreferences")!)
            request.HTTPMethod = "POST"
            
            let userName = CommonFunctions.getUserName()
            let postString = "username=\(userName)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard error == nil && data != nil else {                                                          // check for fundamental
                        completionHandler(nil,error)
                        return
                    }
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        completionHandler(nil, createLocalError())
                    }
                    XMLConverter.convertXMLData(data!, completion: { (success, dictionary, error) -> Void in
                        if success
                        {
                            completionHandler(dictionary,nil)
                        }
                        else
                        {
                            completionHandler(nil, createLocalError())
                        }
                    })
                })
            }
            task.resume()
        }
        else
        {
            completionHandler(nil, createNoInternetError())
        }
    }
    
    class func createLocalError() -> NSError
    {
        return NSError(domain: "Daimler", code: 100, userInfo: [NSLocalizedFailureReasonErrorKey : "Please try again later."])
    }
    
    class func createNoInternetError() -> NSError
    {
        return NSError(domain: "Daimler", code: 101, userInfo: [NSLocalizedFailureReasonErrorKey : "Check your internet and try again."])
    }
    
    class func checkInternetConnection() -> Bool
    {
       let reachabilty = Reachability.reachabilityForInternetConnection()
        if let reachable =  reachabilty?.isReachable() {
            return  reachable
        }
        return false
    }
    
    class func getDomainUrl() -> String
    {
        if let domainUrl = NSUserDefaults.standardUserDefaults().objectForKey("domain_Url") as? String
        {
            return domainUrl
        }
        return domainUrl
    }    
}
