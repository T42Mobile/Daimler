
//
//LocationVC.swift
//  Daimler
//
//  Created by Developer on 27/05/16.

//  Copyright © 2016 benz. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

enum IncidentType
{
    case Major
    case P1
    case P2
}

class IncidentDetailModel : NSObject
{
    var assignedToGroup : String = ""
    var assignedToIndividual : String = ""
    var bridgeNumber : String = ""
    var callCounter : String = ""
    var classification : String = ""
    var client : String = ""
    var component : String = ""
    var componentType : String = ""
    var creationDate : String = ""
    var details : String = ""
    var escalationStage : String = ""
    var externalSystemId : String = ""
    var externalSystemName : String = ""
    var incidentCount : String = ""
    var incidentType : String = ""
    var lastModifiedBy : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var modificationDate : String = ""
    var ownerDepartment : String = ""
    var ownerFirstName : String = ""
    var ownerLastName : String = ""
    var ownerPlant : String = ""
    var plantName : String = ""
    var priority : String = ""
    var regionName : String = ""
    var serviceDeskNumber : String = ""
    var shortDescription : String = ""
    var slaTime : String = ""
    var source : String = ""
    var status : String = ""
    var statusAttribute : String = ""
    var submitter : String = ""
    var ticketId : String = ""
    var typeAttribute : String = ""
    var coordinate: CLLocationCoordinate2D!
    
    convenience init(dictionary : NSDictionary) {
        self.init()
        
        self.assignedToGroup = dictionary.objectForKey("ASSIGNED_TO_GROUP") as! String
        self.assignedToIndividual = dictionary.objectForKey("ASSIGNED_TO_INDIVIDUAL") as! String
        self.bridgeNumber = dictionary.objectForKey("BRIDGE_NUMBER") as! String
        self.callCounter  = dictionary.objectForKey("CALL_COUNTER") as! String
        self.classification = dictionary.objectForKey("CLASSIFICATION") as! String
        self.client  = dictionary.objectForKey("CLIENT") as! String
        self.component  = dictionary.objectForKey("COMPONENT") as! String
        self.componentType  = dictionary.objectForKey("COMPONENT_TYPE") as! String
        self.creationDate  = dictionary.objectForKey("CREATION_DATE") as! String
        self.details  = dictionary.objectForKey("DETAILS") as! String
        self.escalationStage  = dictionary.objectForKey("ESCALATION_STAGE") as! String
        self.externalSystemId  = dictionary.objectForKey("EXTERNAL_SYSTEM_ID") as! String
        self.externalSystemName  = dictionary.objectForKey("EXTERNAL_SYSTEM_NAME") as! String
        self.incidentType = dictionary.objectForKey("INCIDENT_TYPE") as! String
        self.lastModifiedBy  = dictionary.objectForKey("LAST_MODIFIED_BY") as! String
        self.latitude  = convertStringCoordinateToDoubleLatitude( dictionary.objectForKey("LATITUDE") as! String)
        self.longitude = convertStringCoordinateToDoubleLatitude(dictionary.objectForKey("LONGITUDE") as! String)
        self.modificationDate  = dictionary.objectForKey("MODIFICATION_DATE") as! String
        self.ownerDepartment  = dictionary.objectForKey("OWNER_DEPARTMENT") as! String
        self.ownerFirstName  = dictionary.objectForKey("OWNER_FIRSTNAME") as! String
        self.ownerLastName  = dictionary.objectForKey("OWNER_LASTNAME") as! String
        self.ownerPlant  = dictionary.objectForKey("OWNER_PLANT") as! String
        self.plantName  = dictionary.objectForKey("PLANT_NAME") as! String
        self.priority  = dictionary.objectForKey("PRIORITY") as! String
        self.regionName = dictionary.objectForKey("REGION_NAME") as! String
        self.serviceDeskNumber  = dictionary.objectForKey("SERVICE_DESK_NUMBER") as! String
        self.shortDescription  = dictionary.objectForKey("SHORT_DESCRIPTION") as! String
        self.slaTime  = dictionary.objectForKey("SLA_TIME") as! String
        self.source  = dictionary.objectForKey("SOURCE") as! String
        self.status  = dictionary.objectForKey("STATUS") as! String
        self.statusAttribute  = dictionary.objectForKey("STATUS_ATTRIBUTE") as! String
        self.submitter  = dictionary.objectForKey("SUBMITTER") as! String
        self.ticketId  = dictionary.objectForKey("TICKET_ID") as! String
        self.typeAttribute  = dictionary.objectForKey("TYPE_ATTRIBUTE") as! String
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func convertStringCoordinateToDoubleLatitude(coordinate : String) -> Double{
        var degree = Double()
        var minutes = Double()
        var direction = Double()
        
        let array = coordinate.componentsSeparatedByString(" ")
        
        for coordinateComponenet in array {
            
            if coordinateComponenet.characters.count > 1 {
                let lastChar = coordinateComponenet.characters.last!
                if lastChar == "°" {
                    degree = Double(String(coordinateComponenet.characters.dropLast()))!
                }
                else if lastChar == "'" {
                    minutes = Double(String(coordinateComponenet.characters.dropLast()))!
                }
                else {
                    if (lastChar == "N") || (lastChar == "E") {
                        direction = 1.0
                    }
                    if (lastChar == "W") || (lastChar == "S") {
                        direction = -1.0
                    }
                }
            }
        }
        
        let result = degree + minutes/60.0 * direction
        return result
    }
    
    class func convertListOfDictionaryIntoIncidentDetail(incidentList : NSArray) -> [IncidentDetailModel]
    {
        var incidentModelArray : [IncidentDetailModel] = []
        for detail in incidentList as! [NSDictionary]
        {
            incidentModelArray.append(IncidentDetailModel.init(dictionary: detail))
        }
        return incidentModelArray
    }
    /**
     Convert list of incident into IncidentDetailModel Array based on incident type
     
     - Parameter incidentList : NSArray
     */
    
    class func filterListOfIncidentBasedOnIncidentType(convertedList : [IncidentDetailModel]) -> [[IncidentDetailModel]]
    {
        var incidentList : [[IncidentDetailModel]] = []
        incidentList.append(filterDetailFromList(convertedList, incidentType: "MAJOR"))
        incidentList.append(filterDetailFromList(convertedList, incidentType: "1"))
        incidentList.append(filterDetailFromList(convertedList, incidentType: "2"))
        
        
        return incidentList
    }
    
    /**
     Filter the list of details from given total incident array based on incident type
     
     - Parameter totalList : [IncidentDetailModel] list of incident model
     - Parameter incidentType : String incident type to be filtered
     - Returns [IncidentDetailModel] filtered incident array
     */
    
    class func filterDetailFromList(totalList : [IncidentDetailModel] , incidentType : String) -> [IncidentDetailModel]
    {
        let filteredList = totalList.filter { (incidentDetail) -> Bool in
            incidentDetail.incidentType == incidentType
        }
        return filteredList
    }
    
}

class IndividualIncidentAnnotation : NSObject , MKAnnotation
{
    var title: String?
    var subtitle: String?
    var incidentDetail : IncidentDetailModel!
    var latitude: Double = 0.0
    var longitude:Double = 0.0
    var ticketId : String = ""
    var annotaitonView: MKAnnotationView!
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class GroupIncidentAnnotation : NSObject , MKAnnotation
{
    var title: String?
    var subtitle: String?
    var incidentDetailList : [IncidentDetailModel] = []
    var latitude: Double = 0.0
    var longitude:Double = 0.0
    var ticketId : String = ""
    var annotaitonView: MKAnnotationView!
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


protocol locationViewDelegate{
    func loadMapForIncidentDetailList(incidentDetailList : [IncidentDetailModel])
}

class LocationVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate , locationViewDelegate {
    
    //Information View
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet var moreDetailHgtCnt: NSLayoutConstraint!
    @IBOutlet var serviceDeskHgtCnt: NSLayoutConstraint!
    
    @IBOutlet var incidentCollectionView: UICollectionView!
    @IBOutlet var incidentCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var callButtonWidthCnt: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var selectedTicket : String = ""
    
    var selectedIncidentDetail : IncidentDetailModel!
    var incidentDetailList : [IncidentDetailModel] = []
    var totalIncidentList : [[IncidentDetailModel]] = []
    var locationManager: CLLocationManager = CLLocationManager()
    
    // MARK: VIEWCONTROLLER DELEGATES
    
    override func viewDidLoad() {
        
        self.navigationController!.navigationBar.barTintColor = GlobalVariables.navigationBarColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title  = "Mobile Incident Tracker"
        
        self.setNavigationBarItem()
        self.findCurrentLocation()
        
        self.setInitialStateForMoreCondition()
        self.segmentControl.selectedSegmentIndex = 0
        self.segmentControlValueChanged(self.segmentControl)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
    }
    
    //MARK:- Other properties
    
    func getListOfIncident()
    {
        let appDelegate = CommonFunctions.getAppDelegate()
        CommonFunctions.showIndicatorView(appDelegate.window! ,isInteractionEnabled: false )
        
        var ticketType : String = "NEW"
        if segmentControl.selectedSegmentIndex == 1
        {
            ticketType = "ALL"
        }
        
        ServiceHelper.getListOfLocations(ticketType, completionHandler : { (detailDictionary, error ) -> Void in
            CommonFunctions.hideIndicatorView(appDelegate.window!)
            if error == nil
            {
                if let locationList = (detailDictionary?.objectForKey("ArrayOfRetTickets") as? NSDictionary)?.objectForKey("RetTickets") as? NSArray
                {
                    self.setTotalIncidentListFromServer(IncidentDetailModel.convertListOfDictionaryIntoIncidentDetail(locationList))
                }
                else
                {
                    self.addListOfAnnotationToMapView(NSDictionary())
                    CommonFunctions.showAlertView("Alert", message : "No tickets available", viewController : self)
                }
            }
            else
            {
                CommonFunctions.showAlertView("Alert", message : error?.localizedDescription, viewController : self)
            }
        })
    }
    
    func addListOfAnnotationToMapView(locationDetailDict : NSDictionary)
    {
        mapView.removeAnnotations(mapView.annotations)
        for key in locationDetailDict.allKeys as! [String]
        {
            let listOfIncident = locationDetailDict.objectForKey(key) as! [IncidentDetailModel]
            if listOfIncident.count == 1
            {
                let incidentDetail = listOfIncident[0]
                let individualAnnotaion = IndividualIncidentAnnotation.init(latitude: incidentDetail.latitude, longitude: incidentDetail.longitude)
                individualAnnotaion.title = incidentDetail.shortDescription
                individualAnnotaion.subtitle = incidentDetail.modificationDate
                individualAnnotaion.incidentDetail = incidentDetail
                self.mapView.addAnnotation(individualAnnotaion)
            }
            else
            {
                let incidentDetail = listOfIncident[0]
                let groupAnnotation = GroupIncidentAnnotation.init(latitude: incidentDetail.latitude, longitude: incidentDetail.longitude)
                groupAnnotation.incidentDetailList = listOfIncident
                groupAnnotation.title = incidentDetail.plantName
                groupAnnotation.subtitle = incidentDetail.ownerPlant
                self.mapView.addAnnotation(groupAnnotation)
            }
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    //MARK: Collection view
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return incidentDetailList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("incidentCell", forIndexPath: indexPath) as! IncidentCollectionViewCell
        
        let incidentDetail = incidentDetailList[indexPath.item]
        
        let incidentType = incidentDetail.incidentType
        
        if incidentType == "MAJOR" {
            cell.incidentTypeImage.image = UIImage(named: "red-baloon")
        }
        else if incidentType == "1" {
            cell.incidentTypeImage.image = UIImage(named: "orange-baloon")
        }
        else if incidentType == "2" {
            cell.incidentTypeImage.image = UIImage(named: "blue-baloon")
        }
        else
        {
            cell.incidentTypeImage.image = UIImage(named: "blue-baloon")
        }
        cell.incidentTitleLbl.text = incidentDetail.ticketId
        cell.incidentSubTitleLbl.text = incidentDetail.shortDescription
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.moveToTimeLineView(incidentDetailList[indexPath.item])
    }
    
    func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAtIndexPath indexPath : NSIndexPath) -> CGSize
    {
        return CGSizeMake(collectionView.frame.width, self.incidentCollectionViewHeight.constant)
    }
    
    //MARK:-- Button Action
    
    @IBAction func detailInformation(sender: AnyObject)
    {
        var ticketType : String = "NEW"
        if segmentControl.selectedSegmentIndex == 1
        {
            ticketType = "ALL"
        }
        
        let locationlist = self.storyboard! .instantiateViewControllerWithIdentifier("push")as! LocationListVC
        locationlist.delegate = self
        locationlist.ticketType = ticketType
        self.navigationController! .pushViewController(locationlist, animated: true)
    }
    
    @IBAction func incidentButtonAction(sender: UIButton)
    {
        let tag = sender.tag - 100
        
        if tag < self.totalIncidentList.count
        {
            let incidentDetailList = self.totalIncidentList[tag]
            if incidentDetailList.count > 0
            {
                self.convertListOfIncidentIntoIdenticalLocation(incidentDetailList)
            }
            else
            {
                if !CommonFunctions.getListOfPrioritySelected().contains(["Major" , "1" , "2"][tag])
                {
                    CommonFunctions.showAlertView("Alert", message: "Sorry, your preference is not set for selected option. To view, please modify your preferences.", viewController: self)
                }
            }
        }
    }
    
    @IBAction func nextButtonAction(sender: AnyObject)
    {
        let visibleIndex = self.incidentCollectionView.indexPathsForVisibleItems()
        if visibleIndex.count > 0
        {
            let indexPath = visibleIndex[0]
            if indexPath.item < incidentDetailList.count
            {
                let nextIndexPath = NSIndexPath(forItem: (indexPath.item + 1 ), inSection: 0)
                self.scrollToIndexPath(nextIndexPath)
            }
        }
    }
    
    
    func scrollToIndexPath(indexPath : NSIndexPath)
    {
        if indexPath.item < incidentDetailList.count   && indexPath.item >= 0
        {
            self.incidentCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            self.checkCollectionViewBtnState(indexPath)
        }
    }
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        let visibleIndex = self.incidentCollectionView.indexPathsForVisibleItems()
        if visibleIndex.count > 0
        {
            let indexPath = visibleIndex[0]
            if indexPath.item != 0
            {
                let previousIndexPath = NSIndexPath(forItem: (indexPath.item - 1 ), inSection: 0)
                self.scrollToIndexPath(previousIndexPath)
            }
        }
        
    }
    
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //
    //    }
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UICollectionView)
        {
            let visibleIndex = self.incidentCollectionView.indexPathsForVisibleItems()
            if visibleIndex.count > 0
            {
                self.scrollToIndexPath(visibleIndex[0])
            }
        }
    }
    func checkCollectionViewBtnState(indexPath : NSIndexPath)
    {
        self.backBtn.hidden = false
        self.nextBtn.hidden = false
        
        if indexPath.item == 0
        {
            self.backBtn.hidden = true
        }
        else if (indexPath.item  + 1) == incidentDetailList.count && indexPath.item != 0
        {
            self.nextBtn.hidden = true
        }
    }
    //MARK:- Navigation
    
    func moveToTimeLineView(incidentDetail : IncidentDetailModel)
    {
        let time = self.storyboard!.instantiateViewControllerWithIdentifier("push1")as! TimelineViewController
        time.incidentDetail = incidentDetail
        self.navigationController!.pushViewController(time, animated: true)
    }
    
    func setTotalIncidentListFromServer(listOfIncident : [IncidentDetailModel])
    {
        self.totalIncidentList = IncidentDetailModel.filterListOfIncidentBasedOnIncidentType(listOfIncident)
        convertListOfIncidentIntoIdenticalLocation(listOfIncident)
    }
    
    func convertListOfIncidentIntoIdenticalLocation(incidentList : [IncidentDetailModel])
    {
        let listOfIdenticalLocation : NSMutableDictionary = NSMutableDictionary()
        if incidentList.count > 0
        {
            for incidentDetail in incidentList
            {
                let locationCoordinate = "\(incidentDetail.latitude)+\(incidentDetail.longitude)"
                var identicalCoordinateArray : NSMutableArray = []
                if let coordinateArray = listOfIdenticalLocation.objectForKey(locationCoordinate) as? NSMutableArray
                {
                    identicalCoordinateArray = coordinateArray
                }
                identicalCoordinateArray.addObject(incidentDetail)
                listOfIdenticalLocation.setObject(identicalCoordinateArray, forKey: locationCoordinate)
            }
        }
        self.addListOfAnnotationToMapView(listOfIdenticalLocation)
    }
    
    //MARK: Location Manager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location
        {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
                if (error != nil) {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                if let placeMarks =  placemarks
                {
                    if let placeMark = placeMarks.first
                    {
                        self.displayLocationInfo(placeMark)
                    }
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
    }
    
    
    //MARK: CUSTOM ACTIONS
    
    func findCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        locationManager.stopUpdatingLocation()
        self.currentLocationLabel.text  = "You are in: \(placemark.locality!), \(placemark.country!)"
    }
    
    @IBAction func actionMoveToTikcetDetails(sender: AnyObject)
    {
        self.moveToTimeLineView(self.selectedIncidentDetail)
    }
    
    @IBAction func serviceDeskButtonAction(sender: AnyObject) {
        
        if let url = NSURL(string: "tel://\(self.selectedIncidentDetail.serviceDeskNumber)")
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func callButtonAction(sender: AnyObject)
    {
        if let url = NSURL(string: "tel://\(self.selectedIncidentDetail.bridgeNumber)")
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func reloadMapViewButtonAction(sender: AnyObject)
    {
        self.getListOfIncident()
    }
    
    @IBAction func segmentControlValueChanged(sender: UISegmentedControl)
    {
        self.getListOfIncident()
    }
    // MARK: MAP VIEW DELEGATES
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(IndividualIncidentAnnotation)
        {
            let individualIncident = annotation as! IndividualIncidentAnnotation
            let annotationView:MKAnnotationView!
            
            if let annotateView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("IndividualIncident") {
                annotationView = annotateView
            }
            else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "IndividualIncident")
                annotationView.canShowCallout = true
                annotationView.centerOffset = CGPointMake(0, -20)
                annotationView.enabled = true
            }
            
            let incidentType = individualIncident.incidentDetail.incidentType
            if incidentType == "MAJOR" {
                annotationView.image = UIImage(named: "red-baloon")
            }
            else if incidentType == "1" {
                annotationView.image = UIImage(named: "orange-baloon")
            }
            else if incidentType == "2" {
                annotationView.image = UIImage(named: "blue-baloon")
            }
            else
            {
                annotationView.image = UIImage(named: "blue-baloon")
            }
            
            return annotationView
        }
        else if annotation.isKindOfClass(GroupIncidentAnnotation)
        {
            let groupIncident = annotation as! GroupIncidentAnnotation
            let annotationView:MKAnnotationView!
            var countLbl : UILabel = UILabel()
            if let annotateView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("GroupIncident") {
                annotationView = annotateView
                if let label  = annotateView.viewWithTag(10) as? UILabel
                {
                    countLbl = label
                }
            }
            else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "GroupIncident")
                annotationView.canShowCallout = true
                annotationView.centerOffset = CGPointMake(0, -20)
                annotationView.enabled = true
                
                let countLabel = UILabel(frame: CGRectMake(20,-10,20,20))
                countLabel.textAlignment = NSTextAlignment.Center
                countLabel.textColor = UIColor.whiteColor()
                countLabel.layer.cornerRadius = 10
                countLabel.layer.masksToBounds = true
                countLabel.backgroundColor = UIColor.blackColor()
                countLabel.tag = 10
                
                countLbl = countLabel
                annotationView.addSubview(countLabel)
            }
            
            countLbl.text = "\(groupIncident.incidentDetailList.count)"
            let incidentType = getMajorIncidentTypeFromList(groupIncident.incidentDetailList)
            if incidentType == "MAJOR" {
                annotationView.image = UIImage(named: "red-baloon")
            }
            else if incidentType == "1" {
                annotationView.image = UIImage(named: "orange-baloon")
            }
            else if incidentType == "2" {
                annotationView.image = UIImage(named: "blue-baloon")
            }
            else
            {
                annotationView.image = UIImage(named: "blue-baloon")
            }
            
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.setInitialStateForMoreCondition()
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation
        {
            self.setInitialStateForMoreCondition()
            if annotation.isKindOfClass(GroupIncidentAnnotation.classForCoder()) {
                
                guard let annotateObject = annotation as? GroupIncidentAnnotation else
                {
                    return
                }
                
                self.incidentDetailList = annotateObject.incidentDetailList
                incidentCollectionViewReload()
                self.incidentCollectionViewHeight.constant = 80
            }
        }
    }
    
    func incidentCollectionViewReload()
    {
        self.reloadCollectionView()
        self.scrollToIndexPath(NSIndexPath(forItem: 0, inSection: 0))
    }
    
    func mapGroupCountClicked(sender : MapGroupButton)
    {
        self.incidentDetailList = sender.incidentDetaillist
        self.incidentCollectionViewHeight.constant = 80
        incidentCollectionViewReload()
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        //self.setInitialStateForMoreCondition()
    }
    
    func setInitialStateForMoreCondition()
    {
        self.moreDetailHgtCnt.constant = 0
        self.serviceDeskHgtCnt.constant = 0
        self.incidentCollectionViewHeight.constant = 0
        self.incidentDetailList = []
        self.reloadCollectionView()
    }
    
    func reloadCollectionView()
    {
        self.incidentCollectionView.layoutIfNeeded()
        self.incidentCollectionView.reloadData()
    }
    
    
    @IBAction func infoButtonAction(sender: AnyObject)
    {
        
        //        if self.annotationArray.count > 0 {
        //            self.performSegueWithIdentifier("MapToLocationList", sender: nil)
        //        }
        
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        if let annotation = view.annotation
        {
            self.setInitialStateForMoreCondition()
            if annotation.isKindOfClass(GroupIncidentAnnotation.classForCoder())
            {
                guard let annotateObject = annotation as? GroupIncidentAnnotation else
                {
                    return
                }
                
                self.incidentDetailList = annotateObject.incidentDetailList
                
                self.incidentCollectionViewHeight.constant = 80
                incidentCollectionViewReload()
            }
            
            if annotation.isKindOfClass(IndividualIncidentAnnotation) {
                guard let annotationLocal = annotation as? IndividualIncidentAnnotation else {
                    return
                }
                self.moreDetailHgtCnt.constant = 100
                self.serviceDeskHgtCnt.constant = 60
                self.callButtonWidthCnt.constant = 0
                self.selectedIncidentDetail = annotationLocal.incidentDetail
                if annotationLocal.incidentDetail.incidentType == "MAJOR" && annotationLocal.incidentDetail.bridgeNumber != "N/A"
                {
                    self.callButtonWidthCnt.constant = 60
                }
            }
        }
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
    
    func removeAllAnnotations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        if segue.identifier == "unwindFromLocationList" {
        //            if let button = sender as? UIButton {
        //                if button.tag == 0 {
        //                    // prepare annotation and readd all contents
        //                    self.filteredArray = self.filterAnnotations(.Major)
        //                }
        //                else if button.tag == 1 {
        //                    self.filteredArray = self.filterAnnotations(.P1)
        //                }
        //                else if button.tag == 2 {
        //                    self.filteredArray = self.filterAnnotations(.P2)
        //                }
        //
        //                self.removeAllAnnotations()
        //                self.mapView.addAnnotations(self.filteredArray)
        //            }
        //        }
        //        else if segue.identifier == "MapToLocationList" {
        //            guard let listVC = segue.destinationViewController as? LocationListVC else {
        //                return
        //            }
        //            listVC.annotationArray = self.annotationArray
        //            listVC.majorArray = self.filterAnnotations(.Major)
        //            listVC.p1Array = self.filterAnnotations(.P1)
        //            listVC.p2Array = self.filterAnnotations(.P2)
        //        }
    }
    
    @IBAction func unwindFromLocationList(segue: UIStoryboardSegue) {
        //        guard let listVC = segue.sourceViewController as? LocationListVC else {
        //            return
        //        }
        //        self.filteredArray = self.filterAnnotations(listVC.selectedFilter)
        //        self.removeAllAnnotations()
        //        self.mapView.addAnnotations(self.filteredArray)
    }
    
    func getMajorIncidentTypeFromList(listOfIncident : [IncidentDetailModel]) -> String
    {
        var incidentTypeArray : [String] = []
        
        for incidentDetail in listOfIncident
        {
            incidentTypeArray.append(incidentDetail.incidentType)
        }
        
        if incidentTypeArray.contains("MAJOR")
        {
            return "MAJOR"
        }
        else if incidentTypeArray.contains("1")
        {
            return "1"
        }
        else if incidentTypeArray.contains("2")
        {
            return "2"
        }
        return "MAJOR"
        
    }
    
    //MARK:- Loacation view Delegate
    
    func loadMapForIncidentDetailList(incidentDetailList: [IncidentDetailModel])
    {
        self.setTotalIncidentListFromServer(incidentDetailList)
    }
    
}



extension LocationVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

