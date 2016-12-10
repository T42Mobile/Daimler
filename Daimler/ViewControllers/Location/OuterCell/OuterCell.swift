//
//  OuterCell.swift
//  NestedTableView
//
//  Created by Dhandapani R on 12/06/16.
//  Copyright © 2016 Dhandapani R. All rights reserved.
//

import UIKit

class OuterCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate {
    
    @IBOutlet weak var viewOnMap: UIButton!
    @IBOutlet weak var viewDetails : UIButton!
    @IBOutlet weak var typeLabelView: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var innerTableView: UITableView!
    @IBOutlet var emptyStateLbl: UILabel!
    
    var incidentList : [IncidentDetailModel] = []
    var selectedIndex : NSIndexPath?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        self.innerTableView.registerNib(UINib.init(nibName: "InnerCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "InnerCell")
        
        self.innerTableView.dataSource = self
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK:- Table view functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidentList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InnerCell") as! InnerCell
        
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            cell.backgroundColor = UIColor(colorLiteralRed: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.7)
        }
        if let selectedIndexPath = selectedIndex
        {
            if selectedIndexPath == indexPath
            {
                cell.backgroundColor = UIColor(colorLiteralRed: 173.0/255.0, green: 204.0/255.0, blue: 217.0/255.0, alpha: 0.7)
            }
            
        }
        
        let incidentDetail = incidentList[indexPath.row]
        cell.innerCellValue.text =  incidentDetail.ticketId + " - " + incidentDetail.shortDescription
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 33
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath
        self.innerTableView.reloadData()
    }
}
