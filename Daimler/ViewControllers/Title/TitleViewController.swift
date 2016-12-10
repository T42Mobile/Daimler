//
//  TitleViewController.swift
//  FLProject
//
//  Created by admin on 11/06/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

let kGreenColor:UIColor = UIColor(red: 0/255, green: 125/255, blue: 143/255, alpha: 1)
let kOrangeColor:UIColor = UIColor(red: 206/255, green: 67/255, blue: 41/255, alpha: 1)
let kVoiletColor:UIColor = UIColor(red: 85/255, green: 55/255, blue: 167/255, alpha: 1)
let kRedColor:UIColor = UIColor(red: 185/255, green: 19/255, blue: 70/255, alpha: 1)
let kPingColor:UIColor = UIColor(red: 164/255, green: 0/255, blue: 162/255, alpha: 1)
let kBlueColor:UIColor = UIColor(red: 18/255, green: 90/255, blue: 188/255, alpha: 1)
let kLightGreenColor:UIColor = UIColor(red: 36/255, green: 160/255, blue: 78/255, alpha: 1)

class TitleViewController: UIViewController , UISearchBarDelegate
{
    
    @IBOutlet weak var employeeView:UIView?
    @IBOutlet weak var managementView:UIView?
    @IBOutlet weak var businessPartnerView:UIView?
    @IBOutlet weak var employeeImgView:UIImageView?
    @IBOutlet weak var managementImgView:UIImageView?
    @IBOutlet weak var businessPartnerImgView:UIImageView?
    @IBOutlet weak var employeeLabel:UILabel?
    @IBOutlet weak var managementLabel:UILabel?
    @IBOutlet weak var businessPartnerLabel:UILabel?
    
    @IBOutlet weak var searchBarBGView:UIView?
    
    @IBOutlet weak var aboutView:UIView?
    @IBOutlet weak var financeView:UIView?
    @IBOutlet weak var operationsView:UIView?
    @IBOutlet weak var mySpaceView:UIView?
    @IBOutlet weak var processView:UIView?
    @IBOutlet weak var majorProjectsView:UIView?
    @IBOutlet weak var latestUpdatesView:UIView?
    @IBOutlet weak var contantsView:UIView?
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        setDefaultUIProperties()
        addTapGestureRecognizersToViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }
    
    func setDefaultUIProperties()
    {
        //Main Options...
        employeeView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        managementView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        businessPartnerView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        employeeImgView?.image = UIImage(named: "employee")
        managementImgView?.image = UIImage(named: "management")
        businessPartnerImgView?.image = UIImage(named: "businesspartner")
        employeeLabel?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        managementLabel?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        businessPartnerLabel?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        //SearchBar...
        searchBarBGView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        
        let blackBackGroundColor = UIColor.clearColor()
        //Add Background Colors...
        aboutView?.backgroundColor = blackBackGroundColor
        financeView?.backgroundColor = blackBackGroundColor
        mySpaceView?.backgroundColor = blackBackGroundColor
        processView?.backgroundColor = blackBackGroundColor
        operationsView?.backgroundColor = blackBackGroundColor
        majorProjectsView?.backgroundColor = blackBackGroundColor
        latestUpdatesView?.backgroundColor = blackBackGroundColor
        contantsView?.backgroundColor = blackBackGroundColor
        
        //Set Image...
        //        aboutImgView?.image = UIImage(named: "about")
        //        financeImgView?.image = UIImage(named: "finance")
        //        mySpaceImgView?.image = UIImage(named: "myspace")
        //        processImgView?.image = UIImage(named: "process")
        //        operationsImgView?.image = UIImage(named: "operations")
        //        majorProjectsImgView?.image = UIImage(named: "projects")
        //        latestUpdatesImgView?.image = UIImage(named: "latestupdates")
        //        contantsImgView?.image = UIImage(named: "contacts")
    }
    
    func addTapGestureRecognizersToViews()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: "operationsViewTapped")
        operationsView!.addGestureRecognizer(tapGesture)
    }
    
    func operationsViewTapped()
    {
        print("operationsViewTapped")
        //Move to next View..
        
        self.performSegueWithIdentifier("ShowDetailsView", sender: nil)
    }
    
    //MARK:- Search bar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
        if searchBar.text?.uppercaseString == "MIT"
        {
            self.performSegueWithIdentifier("ShowDetailsView", sender: nil)
        }
    }
    
}
