//
//  TicketTimeLineVC.swift
//  Daimler
//
//  Created by Jayavelu R on 29/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

enum TicketStatus: Int {
    case NotYetStarted = 1
    case InProgress
    case Completed
}

class TicketTimeLineVC: UIViewController {
    
    var arrayOfTicketTimelineDetails: [[String: AnyObject]] = [
        [
            "title": "Ticket Open",
            "time": "10:00 AM",
            "status": 3
        ],
        [
            "title": "Identify root cause",
            "time": "12:00 PM",
            "status": 3
        ],
        [
            "title": "Working on issue",
            "time": "01:00 PM",
            "status": 2
        ],
        [
            "title": "Suggested resolution",
            "time": "01:30 PM",
            "status": 1
        ],
        [
            "title": "Approvals / Execution",
            "time": "02:40 PM",
            "status": 1
        ],
        [
            "title": "Ticket Close",
            "time": "03:45 PM",
            "status": 1
        ]
    ]
    
    override func viewDidLoad() {
        print("Timeline view get loaded")
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfTicketTimelineDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TicketTimeLineTableViewCell", forIndexPath: indexPath) as! TicketTimeLineTableViewCell
        cell.selectionStyle             = .None
        cell.accessoryType              = .None
        
        switch  self.arrayOfTicketTimelineDetails[indexPath.row]["status"] as! Int {
        case 2:
            cell.statusIndicatorView.backgroundColor = GlobalVariables.indicatorBlueColor()
            cell.titleLabel.textColor   = GlobalVariables.indicatorBlueColor()
            cell.timeLabel.textColor    = GlobalVariables.indicatorBlueColor()
            cell.titleLabel.text            = self.arrayOfTicketTimelineDetails[indexPath.row]["title"] as? String
            cell.timeLabel.text             = self.arrayOfTicketTimelineDetails[indexPath.row]["time"] as? String
        case 3:
            cell.statusIndicatorView.backgroundColor = GlobalVariables.indicatorGrayColor()
            cell.titleLabel.textColor   = GlobalVariables.indicatorGrayColor()
            cell.timeLabel.textColor    = GlobalVariables.indicatorGrayColor()
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.arrayOfTicketTimelineDetails[indexPath.row]["title"] as! String)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.titleLabel.attributedText  = attributeString
            
            let attributeTimeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.arrayOfTicketTimelineDetails[indexPath.row]["time"] as! String)
            attributeTimeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeTimeString.length))
            cell.timeLabel.attributedText   = attributeTimeString
        default:
            cell.statusIndicatorView.backgroundColor = UIColor.whiteColor()
            cell.titleLabel.textColor   = UIColor.blackColor()
            cell.timeLabel.textColor    = UIColor.blackColor()
            cell.titleLabel.text            = self.arrayOfTicketTimelineDetails[indexPath.row]["title"] as? String
            cell.timeLabel.text             = self.arrayOfTicketTimelineDetails[indexPath.row]["time"] as? String
        }
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}
