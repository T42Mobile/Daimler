//
//  PreferencesViewController.swift
//  Daimler
//
//  Created by Suresh on 01/07/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class PreferenceModel : NSObject
{
    var titleText : String = ""
    var titleId : String = ""
    var isSelected : Bool = false
}

class PreferencesViewController: UIViewController, UITableViewDataSource , UITableViewDelegate
{

    @IBOutlet var priorityTableView: UITableView!
    @IBOutlet var regionTableView: UITableView!
    @IBOutlet var timeZoneTableView: UITableView!
    @IBOutlet var timeZoneTableViewHeight: NSLayoutConstraint!
    @IBOutlet var selectedTimeZoneLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    var regionDetailArray : [PreferenceModel] = []
    var priorityDetailArray : [PreferenceModel] = []
    var timeZoneArray : [String] = []
    var selectedTimeZoneText : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.timeZoneArray = getTimeZoneList()
        
        setselectedTimeZoneTextForLabel(getSelectedTimeZoneText())
        //self.regionTableView.reloadData()
        //self.getRegionsFromServer()
        self.getListOfPriority()
    }
    
    //MARK:- Table View delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 1
        {
            return regionDetailArray.count
        }
        else if tableView.tag == 2
        {
            return priorityDetailArray.count
        }
        else if tableView.tag == 3
        {
            return timeZoneArray.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if tableView.tag == 3
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("timeZoneCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = timeZoneArray[indexPath.row]

            return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCellWithIdentifier("preferenceCell", forIndexPath: indexPath) as! PreferenceTableViewCell
        
        var cellDetail : PreferenceModel!
        
        if tableView.tag == 1
        {
            cellDetail = regionDetailArray[indexPath.row]
        }
        else if tableView.tag == 2
        {
            cellDetail = priorityDetailArray[indexPath.row]
        }
        
        cell.titleLbl.text = cellDetail.titleText
        if cellDetail.isSelected
        {
            cell.selectedImageView.image = UIImage(named: "selected")
        }
        else
        {
            cell.selectedImageView.image = UIImage(named: "unselected")
        }
        
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            cell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
        
        return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if tableView.tag == 3
        {
            self.setselectedTimeZoneTextForLabel(timeZoneArray[indexPath.row])
        }
        else
        {
            var cellDetail : PreferenceModel!
            
            if tableView.tag == 1
            {
                cellDetail = regionDetailArray[indexPath.row]
            }
            else if tableView.tag == 2
            {
                cellDetail = priorityDetailArray[indexPath.row]
            }
            
            cellDetail.isSelected = !cellDetail.isSelected
            tableView.reloadData()
        }
    }
    
    //MARK:- Other functions
    
    func convertListOfRegionIntoModel(regionList : NSArray)
    {
        let selectedRegionId = CommonFunctions.getListOfRegionSelected()
        self.regionDetailArray.removeAll()
        for regionDetail in regionList as! [NSDictionary]
        {
            let regionModel : PreferenceModel = PreferenceModel()
            regionModel.titleText = regionDetail.objectForKey("REGION_NAME") as! String
            regionModel.titleId = regionDetail.objectForKey("REGION_ID") as! String
            
            if selectedRegionId.contains(regionModel.titleText) || selectedRegionId.count == 0
            {
                regionModel.isSelected = true
            }
            regionDetailArray.append(regionModel)
        }
        
        if selectedRegionId.count == 0
        {
            let selectedRegionName = CommonFunctions.getListOfSelectedRegionName(regionDetailArray)
            CommonFunctions.saveListOfSelectedRegion(selectedRegionName)
        }
        self.getListOfPriority()
        self.regionTableView.reloadData()
    }
    
    func getListOfPriority()
    {
        self.priorityDetailArray.removeAll()
        let selectedPriority : [String] = CommonFunctions.getListOfPrioritySelected()
        
        let priorityList : [String] = ["Major" , "1" , "2"]
        let priorityName : [String] = ["MAJOR" , "P1" , "P2"]
        for index : Int in 0 ..< priorityList.count
        {
            let priorityModel : PreferenceModel = PreferenceModel()
            
            priorityModel.titleId = priorityList[index]
            priorityModel.titleText = priorityName[index]
            if selectedPriority.contains(priorityModel.titleId)
            {
                priorityModel.isSelected = true
            }
            self.priorityDetailArray.append(priorityModel)
        }
        self.priorityTableView.reloadData()
    }
    
    func getRegionsFromServer()
    {
        CommonFunctions.showIndicatorView(self.view, isInteractionEnabled: false)
        ServiceHelper.getRegions { (detailDict, error) -> Void in
            CommonFunctions.hideIndicatorView(self.view)
            if error == nil
            {
                if let regionList = (detailDict?.objectForKey("ArrayOfRetRegions") as? NSDictionary)?.objectForKey("RetRegions") as? NSArray
                {
                    self.convertListOfRegionIntoModel(regionList)
                }
                else
                {
                    
                }
            }
            else
            {
                CommonFunctions.showAlertView("Alert", message : error?.localizedDescription, viewController : self)
            }
        }
    }
    
    func getTimeZoneList() ->[String]
    {
        var timeZoneList : [String] = []
        
        let filteredTimeZoneArray = NSTimeZone.knownTimeZoneNames().sort { (timeZoneName1, timeZoneName2) -> Bool in
            let timeZone1 = NSTimeZone(name: timeZoneName1)!
            let timeZone2 = NSTimeZone(name: timeZoneName2)!
            return timeZone1.secondsFromGMT < timeZone2.secondsFromGMT
        }
        
        for timeZoneName in filteredTimeZoneArray
        {
            if let timeZone = NSTimeZone(name: timeZoneName)
            {
                let hours = timeZone.secondsFromGMT / 3600
                var minutes = (timeZone.secondsFromGMT / 60) % 60
                
                var timeDifference : String = ""
                if hours >= 0
                {
                    timeDifference = "+"
                }
                
                if minutes < 0
                {
                    minutes = minutes * -1
                }
                
                let timeZoneString = String(format: "UTC %@ %02d:%02d (%@)", timeDifference,hours,minutes,timeZoneName)
                
                timeZoneList.append(timeZoneString)
            }
        }
        return timeZoneList
    }
    
    func sortAllTimeZoneBasedOnUTCDifference()
    {
        let filteredTimeZoneArray = NSTimeZone.knownTimeZoneNames().sort { (timeZoneName1, timeZoneName2) -> Bool in
            let timeZone1 = NSTimeZone(name: timeZoneName1)!
            let timeZone2 = NSTimeZone(name: timeZoneName2)!
            return timeZone1.secondsFromGMT > timeZone2.secondsFromGMT
        }
        print(filteredTimeZoneArray)
    }
    
    
    
    func getSelectedTimeZoneText() -> String
    {
        if let selectedTimeZone = NSUserDefaults.standardUserDefaults().objectForKey("selectedTimeZone") as? String
        {
            return selectedTimeZone
        }
        else
        {
            return "UTC+05:30 (Asia/Kolkata)"
        }
    }
    
    //MARK:- Button action
    
    @IBAction func timeZoneButtonAction(sender: AnyObject)
    {
        timeZoneTableViewHeight.constant = 300
        timeZoneTableView.reloadData()
        //self.scrollView.setContentOffset(CGPointMake(0, scrollView.contentSize.height - 300), animated: true)
    }
    
    func setselectedTimeZoneTextForLabel(selectedText : String)
    {
        self.selectedTimeZoneText = selectedText
        self.timeZoneTableViewHeight.constant = 0
        self.selectedTimeZoneLbl.text = self.selectedTimeZoneText
        self.timeZoneTableView.setContentOffset(CGPointZero, animated: false)
        
    }
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonAction(sender: AnyObject)
    {
        
        let selectedRegion = CommonFunctions.convertArrayOfStringIntoString(CommonFunctions.getListOfRegionSelected())
        
        //let selectedRegion = CommonFunctions.convertArrayOfStringIntoString(CommonFunctions.getListOfSelectedRegionName(self.regionDetailArray))
        
        let selectedPriority = CommonFunctions.convertArrayOfStringIntoString(CommonFunctions.getListOfSelectedPriority(self.priorityDetailArray))
        let userName = CommonFunctions.getUserName()
        //        if selectedRegion == ""
        //        {
        //            CommonFunctions.showAlertView("Alert", message: "Please select any one region", viewController: self)
        //        }
        //        else
        
        if selectedPriority == ""
        {
            CommonFunctions.showAlertView("Alert", message: "Please select any one priority", viewController: self)
        }
        else
        {
            let postString = "User_Name=\(userName)&Regions=\(selectedRegion)&Priorities=\(selectedPriority)&Time_Zone=\(selectedTimeZoneText)"
            
            let appDelegate = CommonFunctions.getAppDelegate()
            
            CommonFunctions.showIndicatorView(appDelegate.window!, isInteractionEnabled: false)
            
            ServiceHelper.savePreferences(postString) { (detailDict, error ) -> Void in
                CommonFunctions.hideIndicatorView(appDelegate.window!)
                print(detailDict)
                if error == nil
                {
                    if let statusMessage = ((detailDict?.objectForKey("ArrayOfSetPreferences") as? NSDictionary)?.objectForKey("SetPreferences") as? NSDictionary)?.objectForKey("message") as? String
                    {
                        if statusMessage.uppercaseString == "SUCCESS"
                        {
                            self.savePreferencesValueToUserDefaults()
                        }
                        else
                        {
                            CommonFunctions.showAlertView("Alert", message : "Please check your internet connection.", viewController : self)
                        }
                    }
                    else
                    {
                        CommonFunctions.showAlertView("Alert", message : "Please check your internet connection.", viewController : self)
                    }
                }
                else
                {
                    CommonFunctions.showAlertView("Alert", message : error?.localizedDescription, viewController : self)
                }
            }
        }
    }
    
    func savePreferencesValueToUserDefaults()
    {
        CommonFunctions.saveListOfSelectedPriority(self.priorityDetailArray)
        CommonFunctions.saveSelectedTimeZone(self.selectedTimeZoneText)
        
        //let selectedRegionName = CommonFunctions.getListOfSelectedRegionName(self.regionDetailArray)
        
        //CommonFunctions.saveListOfSelectedRegion(selectedRegionName)
        
        CommonFunctions.showAlertView("Success", message : "Your preferences saved successfully.", viewController : self)
    }
}
