//
//  TitleDetailsViewController.swift
//  FLProject
//
//  Created by admin on 12/06/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

let kLightBlueColor:UIColor = UIColor(red: 40/255, green: 129/255, blue: 181/255, alpha: 1)

class TitleDetailsViewController: UIViewController , NSXMLParserDelegate{
    
    @IBOutlet weak var selectedItemView:UIView?
    @IBOutlet weak var selectedItemImgView:UIImageView?
    @IBOutlet weak var selectedItemLabel:UILabel?
    
    @IBOutlet weak var bottomBGView:UIView?
    @IBOutlet weak var reportsView:UIView?
    @IBOutlet weak var mitView:UIView?
    @IBOutlet weak var dashboardsView:UIView?
    @IBOutlet weak var contactsView:UIView?
    
    //    @IBOutlet weak var reportsBlurredView:UIView?
    //    @IBOutlet weak var mitBlurredView:UIView?
    //    @IBOutlet weak var dashboardsBlurredView:UIView?
    //    @IBOutlet weak var contactsBlurredView:UIView?
    
    @IBOutlet weak var reportsImgView:UIImageView?
    @IBOutlet weak var mitImgView:UIImageView?
    @IBOutlet weak var dashboardsImgView:UIImageView?
    @IBOutlet weak var contactsImgView:UIImageView?
    
    @IBOutlet var incidentCountLbl: UILabel!
    @IBOutlet var incidentCountView: UIView!
    @IBOutlet var incidentCountBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setDefaultUIProperties()
        addTapGestureRecognizersToViews()
        getIncidentCount()
        
        incidentCountBtn.layer.borderColor = UIColor.whiteColor().CGColor
        incidentCountBtn.layer.borderWidth = 1.0
        incidentCountBtn.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showIndicatorView()
    {
        let screenFrame = UIScreen.mainScreen().bounds
        let indicatorView : UIView = UIView(frame : screenFrame )
        let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
        let xPosition = (screenFrame.size.width / 2 ) - 10
        let YPosition = (screenFrame.size.height / 2 ) - 10
        activityIndicator.frame = CGRectMake(xPosition , YPosition , 20 , 20)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.color = UIColor.whiteColor()
        
        indicatorView.addSubview(activityIndicator)
        
        indicatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        indicatorView.tag = 100
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.userInteractionEnabled = false
        
        appDelegate.window?.addSubview(indicatorView)
        
    }
    
    func hideIndicatorView()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.userInteractionEnabled = true
        if let indicatorView = appDelegate.window?.viewWithTag(100)
        {
            indicatorView.removeFromSuperview()
        }
    }
    
    func setDefaultUIProperties()
    {
        //Selected Item...
        selectedItemView?.backgroundColor = kLightBlueColor
        selectedItemImgView?.image = UIImage(named: "operations")
        selectedItemLabel?.text = "Operations"
        
        bottomBGView?.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.6)
        
        //Add Background Colors...
        let blackColor = UIColor.blackColor()
        reportsView?.backgroundColor = blackColor
        mitView?.backgroundColor = blackColor
        dashboardsView?.backgroundColor = blackColor
        contactsView?.backgroundColor = blackColor
        
        //        reportsBlurredView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        //        mitBlurredView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        //        dashboardsBlurredView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        //        contactsBlurredView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        //
        //        //Set Image...
        //        reportsImgView?.image = UIImage(named: "projects")
        //        mitImgView?.image = UIImage(named: "map")
        //        dashboardsImgView?.image = UIImage(named: "dashboard")
        //        contactsImgView?.image = UIImage(named: "contacts")
    }
    
    func getIncidentCount()
    {
        ServiceHelper.getIncidentCount { (detailDict, error ) -> Void in
            
            if error == nil
            {
                if let incidentCount  = ((detailDict?.objectForKey("ArrayOfRetIncidentCount") as? NSDictionary)?.objectForKey("RetIncidentCount") as? NSDictionary)?.objectForKey("INCIDENT_COUNT") as? String
                {
                    self.incidentCountBtn.setTitle(incidentCount, forState: UIControlState.Normal)
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
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func addTapGestureRecognizersToViews()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: "mitViewTapped")
        mitView!.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: "contactsViewTapped")
        contactsView!.addGestureRecognizer(tapGesture1)
    }
    
    func mitViewTapped()
    {
        print("mitViewTapped")
        //Move to next View..label
        
        let mainViewController = storyboard?.instantiateViewControllerWithIdentifier("LocationVC") as! LocationVC
        let leftViewController = storyboard?.instantiateViewControllerWithIdentifier("HamburgerSideMenuVC") as! HamburgerSideMenuVC
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.presentViewController(slideMenuController, animated: true)
            {
                
        }
    }
    
    func contactsViewTapped()
    {
        //        print("mitViewTapped")
        //        //Move to next View..
        //
        //        let navVC = storyboard?.instantiateViewControllerWithIdentifier("TimelineNavVC") as! UINavigationController
        //        self.presentViewController(navVC, animated: true, completion: nil)
    }
}
