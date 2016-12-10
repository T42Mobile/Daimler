//
//  TicketDetailsVC.swift
//  Daimler
//
//  Created by Jayavelu R on 28/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class TicketDetailsVC: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var arrayOfTicketDetails: [[String: AnyObject]] = [
        [
            "title": "Ticket ID",
            "subtitle": "987654321"
        ],
        [
            "title": "Category",
            "subtitle": "Network Problem"
        ],
        [
            "title": "Short Description",
            "subtitle": "Local area connection is not working"
        ],
        [
            "title": "Created Date",
            "subtitle": "Mar 17, 2016 10:08:13 AM"
        ],
        [
            "title": "Solution Date",
            "subtitle": "None"
        ],
        [
            "title": "Ticket Priority",
            "subtitle": "P1"
        ],
        [
            "title": "Address",
            "subtitle": "Chennai - 600096"
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
        print(self.view.frame)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfTicketDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TicketDetailsTableViewCell", forIndexPath: indexPath) as! TicketDetailsTableViewCell
        cell.selectionStyle             = .None
        cell.accessoryType              = .None
        cell.titleLabel.text            = self.arrayOfTicketDetails[indexPath.row]["title"] as? String
        cell.subtitleLabel.text         = self.arrayOfTicketDetails[indexPath.row]["subtitle"] as? String
        return cell
    }

    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}
