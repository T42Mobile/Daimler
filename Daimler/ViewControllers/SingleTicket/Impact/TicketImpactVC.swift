//
//  ImpactVC.swift
//  Daimler
//
//  Created by Jayavelu R on 29/05/16.
//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit

class TicketImpactVC: UIViewController {
    
    var arrayOfHeaders: [String] = ["Applications Affected"]
    var arrayOfImpacts: [[String: AnyObject]] = [
        [
            "name": "SAP",
            "count": 50
        ],
        [
            "name": "Azure",
            "count": 100
        ],
        [
            "name": "Users Affected",
            "count": 200
        ],
        [
            "name": "Customers Affected",
            "count": 400
        ],
        [
            "name": "Networks Affected",
            "count": 800
        ]
    ]
    
    override func viewDidLoad() {
        print("Timeline view get loaded")
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TicketImpactTableViewCell", forIndexPath: indexPath) as! TicketImpactTableViewCell
        cell.selectionStyle             = .None
        cell.accessoryType              = .None
        cell.titleLabel.text            = self.arrayOfImpacts[indexPath.row]["name"] as? String
        cell.countLabel.text            = "\(self.arrayOfImpacts[indexPath.row].count as Int)"
        return cell
    }

    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}
