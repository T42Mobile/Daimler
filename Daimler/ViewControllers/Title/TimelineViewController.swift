
import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate {
    
    var ticketTitleArray = [String]()
    var ticketDetailsArray = [String]()
    var serviceticketDetailsArray = [String]()
    
    var isTimelineSelected:Bool = false
    @IBOutlet weak var serviceDeskView:UIView?
    
    @IBOutlet weak var selectionIndicatorView1:UIView?
    @IBOutlet weak var selectionIndicatorView2:UIView?
    
    @IBOutlet weak var timelineInfoView:UIView?
    @IBOutlet weak var timelineDetailsView:UIView?
    
    @IBOutlet weak var detailsView:UIView?
    
    @IBOutlet weak var timelineLabel:UILabel?
    @IBOutlet weak var detailsLabel:UILabel?
    
    @IBOutlet weak var createdLabel:UILabel?
    @IBOutlet weak var lastModifiedLabel:UILabel?
    @IBOutlet weak var closureExpLabel:UILabel?
    @IBOutlet weak var timezoneLabel: UILabel!
    
    @IBOutlet weak var ticketOpenImgView:UIImageView?
    @IBOutlet weak var assignedImgView:UIImageView?
    @IBOutlet weak var workInProgressImgView:UIImageView?
    @IBOutlet weak var sleepImgView:UIImageView?
    @IBOutlet weak var ticketClosureImgView:UIImageView?
    
    @IBOutlet weak var greenIndicationView:UIView?
    @IBOutlet weak var redIndicationView:UIView?
    
    @IBOutlet weak var listTableView:UITableView?
    
    //MARK:- Time Status
    
    @IBOutlet var ticketOpenTimeLbl: UILabel!
    @IBOutlet var ticketAssignedTimeLbl: UILabel!
    @IBOutlet var ticketWIPTimeLbl: UILabel!
    @IBOutlet var ticketSleepTimeLbl: UILabel!
    @IBOutlet var ticketClosedTimeLbl: UILabel!
    
    @IBOutlet var ticketOpenStatusImgView: UIImageView!
    @IBOutlet var ticketAssignedStatusImgView: UIImageView!
    @IBOutlet var ticketWIPStatusImgView: UIImageView!
    @IBOutlet var ticketSleepStatusImgView: UIImageView!
    @IBOutlet var ticketClosedStatusImgView: UIImageView!
    
    //MARK:-- Progress View
    
    @IBOutlet weak var progressOuterView: UIView!
    @IBOutlet weak var createdProgressLabel: UILabel!
    @IBOutlet weak var SLAProgressLabel: UILabel!
    @IBOutlet var progressStatusView: UIView!
    @IBOutlet var progressHgtCnt: NSLayoutConstraint!
    @IBOutlet var progressImageView: UIImageView!
    
    @IBOutlet var serviceDeskHeightConstraint: NSLayoutConstraint!
    @IBOutlet var caalButtonWidthCnt: NSLayoutConstraint!
    //MARK:- Time Line Status
    
    
    var tagSelected = [String]()
    var detailDictionary : [String : String] = [String : String]()
    var parser = NSXMLParser()
    var foundCharacters = ""
    var timeLineDictionary : [String : String] = [String : String]()
    var strXMLData:String = ""
    var currentElement = NSString()
    
    var incidentDetail : IncidentDetailModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDefaultUIProperties()
        addTapGestureRecognizersToViews()
        
        //Set Default Value..
        isTimelineSelected = true
        updateUIOnSelection()
        updateTimelineIndicatorUI()
        
        getTicketDetailsData()
        
        if incidentDetail.incidentType == "MAJOR"
        {
            self.caalButtonWidthCnt.constant = 44
        }
        else
        {
            self.caalButtonWidthCnt.constant = 0
        }
        
        self.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTicketDetailsData()
    {
        ticketTitleArray = ["Ticket ID", "Priority", "Status", "Creation Date", "Last Modification Date","SLA Time","Time Zone", "Assigned to Group", "Short Description", "Log Details",  "Owner Plant", "Owner Department", "Classification", "Component Type"]
        
        ticketDetailsArray.append(incidentDetail.ticketId )
        ticketDetailsArray.append(incidentDetail.priority )
        ticketDetailsArray.append(incidentDetail.status )
        ticketDetailsArray.append(incidentDetail.creationDate )
        ticketDetailsArray.append(incidentDetail.modificationDate )
        ticketDetailsArray.append(incidentDetail.slaTime )
        ticketDetailsArray.append(incidentDetail.timeZone )
        ticketDetailsArray.append(incidentDetail.assignedToGroup )
        ticketDetailsArray.append(incidentDetail.shortDescription )
        ticketDetailsArray.append(incidentDetail.details )
        ticketDetailsArray.append(incidentDetail.plantName )
        ticketDetailsArray.append(incidentDetail.ownerDepartment )
        ticketDetailsArray.append(incidentDetail.classification )
        ticketDetailsArray.append(incidentDetail.componentType )
    }
    
    func updateTimelineIndicatorUI()
    {
        let isWarningExist:Bool = isWarningExistOnTicket()
        
        redIndicationView?.hidden = !isWarningExist
    }
    
    func isWarningExistOnTicket() -> Bool
    {
        return true
    }
    
    func updateUIOnSelection(){
        
        selectionIndicatorView1?.hidden = !isTimelineSelected
        selectionIndicatorView2?.hidden = isTimelineSelected
        
        //Timeline View..
        timelineInfoView?.hidden = !isTimelineSelected
        timelineDetailsView?.hidden = !isTimelineSelected
        
        //Details View..
        detailsView?.hidden = isTimelineSelected
    }
    
    func setDefaultUIProperties()
    {
        self.title = "Ticket Details"
        
        timelineLabel?.userInteractionEnabled = true
        detailsLabel?.userInteractionEnabled = true
        
        //        createdLabel?.text = "May 17, 2016 10:00:00 AM\nCreated"
        //        lastModifiedLabel?.text = "May 17, 2016 10:30:00 AM\nLast Modified"
        
        //        //Back Button...
        //        let button = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backButtonClicked:")
        //        button.tintColor = UIColor.whiteColor()
        //        self.navigationItem.leftBarButtonItem = button;
        
        //TableView..
        listTableView?.delegate = self
        listTableView?.dataSource = self
        
        self.createdLabel?.text = incidentDetail.creationDate + "\n Created"
        self.lastModifiedLabel?.text = incidentDetail.modificationDate + "\n Last Modified"
        self.closureExpLabel?.text = incidentDetail.slaTime + "\n Closure Expected by SLA"
        self.timezoneLabel.text = incidentDetail.timeZone
        
        let selectedImage = UIImage(named: "circleSelected")
        let unselectedImage  = UIImage(named: "circleUnSelected")
        
        self.ticketOpenStatusImgView.image = unselectedImage
        self.ticketAssignedStatusImgView.image = unselectedImage
        self.ticketWIPStatusImgView.image = unselectedImage
        self.ticketSleepStatusImgView.image = unselectedImage
        self.ticketClosedStatusImgView.image = unselectedImage
        
        let createdDate = convertToDate(incidentDetail.creationDate)
        
        self.ticketOpenTimeLbl.text = self.getTimeFromGivenDateAndIntervel(createdDate, timeInterval: (60 * 0.0))
        self.ticketAssignedTimeLbl.text = self.getTimeFromGivenDateAndIntervel(createdDate, timeInterval: (60 * 45.0))
        self.ticketWIPTimeLbl.text = self.getTimeFromGivenDateAndIntervel(createdDate, timeInterval: (60 * 90.0))
        self.ticketSleepTimeLbl.text = self.getTimeFromGivenDateAndIntervel(createdDate, timeInterval: (60 * 135.0))
        self.ticketClosedTimeLbl.text = self.getTimeFromGivenDateAndIntervel(createdDate, timeInterval: (60 * 180.0))
        
        let status = incidentDetail.status.uppercaseString
        
        
        
        if status == "OPEN"
        {
            self.ticketOpenStatusImgView.image = selectedImage
        }
        else if status == "ASSIGNED"
        {
           
            self.ticketAssignedStatusImgView.image = selectedImage
        }
        else if status == "WIP"
        {
            
            self.ticketWIPStatusImgView.image = selectedImage
        }
        else if status == "SLEEP"
        {
            
            self.ticketSleepStatusImgView.image = selectedImage
        }
        else if status == "CLOSED"
        {
            self.ticketClosedStatusImgView.image = selectedImage
        }
        
        if incidentDetail.slaTime != "N/A"
        {
            var heightCnt : CGFloat = 0
            var progressImage : String = ""
            self.progressOuterView.hidden = false
            self.createdProgressLabel.hidden = false
            self.SLAProgressLabel.hidden = false
            let slaTimeDate = convertToDate(incidentDetail.slaTime)
            if NSDate().compare(slaTimeDate) == NSComparisonResult.OrderedDescending
            {
                progressImage = "bar-red"
                heightCnt = 1
            }
            else
            {
                let createdDate = convertToDate(incidentDetail.creationDate)
                let differenceInTime = slaTimeDate.timeIntervalSinceDate(createdDate)
                let currentInterval = NSDate().timeIntervalSinceDate(createdDate)
                
                let ratio = currentInterval / differenceInTime
                
                if ratio <= 0.25
                {
                    heightCnt = 0.25
                    progressImage = "bar-gr"
                }
                else if ratio <= 0.5
                {
                    heightCnt = 0.5
                    progressImage = "bar-gr-ye"
                }
                else if ratio <= 0.75
                {
                    heightCnt = 0.75
                    progressImage = "bar-all"
                }
                else
                {
                    heightCnt = 1
                    progressImage = "bar-all"
                }
            }
            self.progressHgtCnt.constant = heightCnt * ((timelineDetailsView?.frame.size.height)! - 80)
            self.progressImageView.image = UIImage(named: progressImage)
        }
        else
        {
            self.progressOuterView.hidden = true
            self.createdProgressLabel.hidden = true
            self.SLAProgressLabel.hidden = true
        }
        
       
    }
    
    func backButtonClicked(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func trimNewLineCharacters(stringValue : String?) -> String
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
    
    func convertToDate(dateString : String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        if let convertedDate = dateFormatter.dateFromString(dateString)
        {
            return convertedDate
        }
        else
        {
            return NSDate()
        }
    }
    
    func getTimeFromGivenDateAndIntervel(date : NSDate , timeInterval : NSTimeInterval) -> String
    {
        let intervelDate = date.dateByAddingTimeInterval(timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(intervelDate)
    }
    
    func addTapGestureRecognizersToViews()
    {
        //        let tapGestureCall = UITapGestureRecognizer(target: self, action: "serviceDeskTapped")
        //        serviceDeskView!.addGestureRecognizer(tapGestureCall)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: "timelineTapped")
        timelineLabel!.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "detailsTapped")
        detailsLabel!.addGestureRecognizer(tapGesture2)
    }
    
    func serviceDeskTapped ()
    {
        
        //        let single = self.storyboard! .instantiateViewControllerWithIdentifier("SingleTicketVC")as! SingleTicketVC
        //        single.bridgeNumber = incidentDetail.bridgeNumber
        //
        //
        //
        //        self.navigationController! .pushViewController(single, animated: true)
    }
    
    func timelineTapped ()
    {
        print("timelineTapped")
        
        isTimelineSelected = true
        updateUIOnSelection()
    }
    
    func detailsTapped ()
    {
        isTimelineSelected = false
        updateUIOnSelection()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == 7)
        {
            let detailStr:String = ticketDetailsArray[indexPath.row]
            let sizeOfString = detailStr.boundingRectWithSize(CGSizeMake(tableView.frame.size.width - 30, 10000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15)],
                context: nil).size
            let floatVal = sizeOfString.height + 55
            
            return floatVal > 90 ? floatVal : 90
        }
        
        return 90
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ticketTitleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailsTableViewCell", forIndexPath: indexPath) as! DetailsTableViewCell
        
        let titleStr:String = ticketTitleArray[indexPath.row]
        cell.headerLabel?.text = titleStr
        
        let detailStr:String = ticketDetailsArray[indexPath.row]
        cell.detailsLabel?.text = detailStr
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func bridgeNumberButtonAction(sender: UIButton)
    {
        if incidentDetail.bridgeNumber != "N/A"
        {
            if let url = NSURL(string: "tel://\(incidentDetail.bridgeNumber)")
            {
                UIApplication.sharedApplication().openURL(url)
            }
            else
            {
                CommonFunctions.showAlertView("Alert", message: "Unable to make a call to the number \(incidentDetail.bridgeNumber)", viewController: self)
            }
        }
        else
        {
            CommonFunctions.showAlertView("Alert", message: "NO MIM number available.", viewController: self)
        }
    }
    
    @IBAction func serviceDeskButtonAction(sender: AnyObject)
    {
        if incidentDetail.serviceDeskNumber != "N/A"
        {
            if let url = NSURL(string: "tel://\(incidentDetail.serviceDeskNumber)")
            {
                UIApplication.sharedApplication().openURL(url)
            }
            else
            {
                CommonFunctions.showAlertView("Alert", message: "Unable to make a call to the number \(incidentDetail.serviceDeskNumber)", viewController: self)
            }
        }
        else
        {
            CommonFunctions.showAlertView("Alert", message: "NO service desk number available.", viewController: self)
        }
    }
}
