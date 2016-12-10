//
//  ViewController.swift
//  NestedTableView
//
//  Created by Dhandapani R on 12/06/16.
//  Copyright © 2016 Dhandapani R. All rights reserved.
//

import UIKit

class LocationListVC: UIViewController{
    
    @IBOutlet weak var outerTableView: UITableView!
    
    
    //MARK:- Variables
    
    //MARK:-- Incident variables
    
    var incidentList : [[IncidentDetailModel]] = []
    var ticketType : String = "NEW"
    
    var selectedFilter:IncidentType = .Major
    
    var delegate : locationViewDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Summary"
        // Do any additional setup after loading the view, typically from a nib.
        self.outerTableView.registerNib(UINib.init(nibName: "OuterCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "OuterCell")
        
        self.getListOfIncident()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Service Helper
    
    /**
    Get list of incident Details from server
    
    */
    
    func getListOfIncident()
    {
        let appDelegate = CommonFunctions.getAppDelegate()
        CommonFunctions.showIndicatorView(appDelegate.window! ,isInteractionEnabled: false )
        ServiceHelper.getListOfLocations(ticketType, completionHandler : { (detailDictionary, error ) -> Void in
            CommonFunctions.hideIndicatorView(appDelegate.window!)
            if error == nil
            {
                if let incidentList = (detailDictionary?.objectForKey("ArrayOfRetTickets") as? NSDictionary)?.objectForKey("RetTickets") as? NSArray
                {
                    self.filterListOfIncidentBasedOnIncidentType(incidentList)
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
        })
    }
    
    //MARK:- Other properties
    
    /**
    Convert list of incident into IncidentDetailModel Array based on incident type
    
    - Parameter incidentList : NSArray
    */
    
    func filterListOfIncidentBasedOnIncidentType(listOfIncidentDetail : NSArray)
    {
        let convertedList = IncidentDetailModel.convertListOfDictionaryIntoIncidentDetail(listOfIncidentDetail)
        self.incidentList = []
        self.incidentList.append(self.filterDetailFromList(convertedList, incidentType: "MAJOR"))
        self.incidentList.append(self.filterDetailFromList(convertedList, incidentType: "1"))
        self.incidentList.append(self.filterDetailFromList(convertedList, incidentType: "2"))
        self.outerTableView.reloadData()
    }
    
    /**
     Filter the list of details from given total incident array based on incident type
     
     - Parameter totalList : [IncidentDetailModel] list of incident model
     - Parameter incidentType : String incident type to be filtered
     - Returns [IncidentDetailModel] filtered incident array
     */
    
    func filterDetailFromList(totalList : [IncidentDetailModel] , incidentType : String) -> [IncidentDetailModel]
    {
        let filteredList = totalList.filter { (incidentDetail) -> Bool in
            incidentDetail.incidentType == incidentType
        }
        return filteredList
    }
    
    
    func unwindToLocationVC(sender: UIButton)
    {
        if let outerTableCell = outerTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as? OuterCell
        {
            var selectedDetailList : [IncidentDetailModel] = []
            if let selectedIndex = outerTableCell.selectedIndex
            {
                selectedDetailList.append(self.incidentList[sender.tag][selectedIndex.row])
            }
            else
            {
                selectedDetailList.appendContentsOf(self.incidentList[sender.tag])
            }
            delegate?.loadMapForIncidentDetailList(selectedDetailList)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}


extension LocationListVC: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.incidentList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OuterCell") as! OuterCell
        cell.backgroundColor = UIColor.blueColor()
        
        if indexPath.section == 0 {
            cell.typeLabelView.text = "Major"
            cell.logoImageView.image = UIImage(named:"red-baloon")
            cell.emptyStateLbl.text = "No incident."
        }
        else if indexPath.section == 1 {
            cell.typeLabelView.text = "P1"
            cell.logoImageView.image = UIImage(named:"orange-baloon")
            cell.emptyStateLbl.text = "No incident."
        }
        else if indexPath.section == 2 {
            cell.typeLabelView.text = "P2"
            cell.logoImageView.image = UIImage(named:"blue-baloon")
            cell.emptyStateLbl.text = "No incident."
            
        }
        cell.incidentList = self.incidentList[indexPath.section]
        cell.innerTableView.reloadData()
        
        if cell.incidentList.count == 0
        {
            cell.emptyStateLbl.hidden = false
        }
        else
        {
            cell.emptyStateLbl.hidden = true
        }
        
        cell.viewOnMap.tag = indexPath.section
        
        cell.viewOnMap.addTarget(self, action:"unwindToLocationVC:", forControlEvents: .TouchUpInside)
        
        cell.viewDetails.tag = indexPath.section
        cell.viewDetails.addTarget(self, action: "detailView:", forControlEvents: .TouchUpInside)
        
        
        return cell
    }
    
    func detailView (sender : UIButton)
    {
        if let outerTableCell = outerTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as? OuterCell
        {
            if let selectedIndex = outerTableCell.selectedIndex
            {
                moveToTimeLineView(self.incidentList[sender.tag][selectedIndex.row])
            }
        }
    }
    
    func moveToTimeLineView(incidentDetail : IncidentDetailModel)
    {
        let time = self.storyboard!.instantiateViewControllerWithIdentifier("push1")as! TimelineViewController
        time.incidentDetail = incidentDetail
        self.navigationController!.pushViewController(time, animated: true)
    }
}





extension LocationListVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return  tableView.frame.height / 3
    }
}

