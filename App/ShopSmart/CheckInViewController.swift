

//
//  CheckInViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/19/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit


class CheckInViewController: UIViewController,EILIndoorLocationManagerDelegate ,ESTBeaconManagerDelegate{
    
    
    /* Indoor Map Params */
    
    @IBOutlet var myPosLabel: UILabel!
    let locationManager : EILIndoorLocationManager  = EILIndoorLocationManager()
    var location: EILLocation!
    var beacons : [Int] = []
    @IBOutlet var myLocationView: EILIndoorLocationView!
    
 
    
    let beaconManager = ESTBeaconManager()
    
    
    @IBOutlet var Menu: UIBarButtonItem!{
        
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the pan gesture to the view.
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        //Setting up Estimote Indoor Location SDK
        
        
        self.locationManager.delegate = self
        
        // Fetch Beacon ID of interest to user
        
       //let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
       // let list_id = prefs.valueForKey("list_id") as! Int
        
      //  fetchBeaconsofInterest(list_id);
       
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "ABA0D8FA-FEAA-D839-DA19-5261FF80DDA7")!,
            major: 16358, minor: 55174, identifier: "monitored region 3"))
            
        
        
        print("Start Region Monitoring")
        

        
        let labelArr = ["Produce","Dairy", "Baked Goods","Health" , "Beverages"]
        
        // You will find the identifier on https://cloud.estimote.com/#/locations
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "nthiagu-s-location-42j")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
           
            
            if let location = location {
                
               
                
                self.location = location
                self.myLocationView.showTrace = true
                self.myLocationView.traceColor = UIColor.greenColor()
                self.myLocationView.rotateOnPositionUpdate = false

                self.myLocationView.drawLocation(location)
                self.locationManager.startMonitoringForLocation(location)
                
                let beaconArr = self.location.beacons;
                var i=0;
                
                for beacon in beaconArr {
               
                var estPB = EILPositionedBeacon()
                estPB = beacon as! EILPositionedBeacon
                
                var estOrientedPointorentation = EILOrientedPoint()
                estOrientedPointorentation = estPB.position as! EILOrientedPoint;
                
                var modestOrientedPointorentation = EILOrientedPoint.init(x: estOrientedPointorentation.x  , y: estOrientedPointorentation.y - 1.0 , orientation: estOrientedPointorentation.orientation)
                
                
                var label1 = UILabel.init(frame: CGRectMake(0, 0, 150, 40))
                
                
              
                label1.text = labelArr[i]
                   
                label1.font = UIFont.init(name: "Arial", size: 9.0)
                
               
                var id = labelArr[i++]
                
                self.myLocationView.drawObjectInBackground(label1, withPosition: modestOrientedPointorentation, identifier: id)
                   
                }
                
                
                self.locationManager.startPositionUpdatesForLocation(self.location)
                
                
                
            } else {
                print("can't fetch location: \(error)")
            }

        
        
        
        }
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /*
    func fetchBeaconsofInterest(list_id: Int)  {
    
        
        
        
        Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/userlistdetail/\(list_id)/?format=json")
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    print("Success: \(JSON)")
                    self.populateData(JSON as! NSArray)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }

    }
    
    
    func populateData(jsonData: NSArray){
        
        if(jsonData.count>0){
            
            for item in jsonData{
                
                let dict = item as! NSMutableDictionary
                let listItem = dict["list_id"] as! Int
                self.beacons.append(listItem)
                
            }
            
            
        }
        
    }*/
    

   func indoorLocationManager(manager: EILIndoorLocationManager!,
        didFailToUpdatePositionWithError error: NSError!) {
            print("failed to update position: \(error)")
    }
    
    
    func indoorLocationManager(manager: EILIndoorLocationManager!,
        didUpdatePosition position: EILOrientedPoint!,
        withAccuracy positionAccuracy: EILPositionAccuracy,
        inLocation location: EILLocation!) {
            
            
            self.myPosLabel.text = NSString(format: "x: %5.2f, y: %5.2f, orientation: %3.0f",
                position.x, position.y, position.orientation) as String
            
            self.myLocationView.updatePosition(position)
            
            
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        
        
    }
    
    
//Beacon monitoring
    
  func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        
       print ("In region")
        let notification = UILocalNotification()
        notification.alertBody =
            "Enter Event - Your gate closes in 47 minutes. " +
            "Current security wait time is 15 minutes, " +
            "and it's a 5 minute walk from security to the gate. " +
        "Looks like you've got plenty of time!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func beaconManager(manager: AnyObject,
        didExitRegion region: CLBeaconRegion) {
            
            print("Exit");
            let notification = UILocalNotification()
            notification.alertBody =
                "Exit Event - Your gate closes in 47 minutes. " +
                "Current security wait time is 15 minutes, " +
                "and it's a 5 minute walk from security to the gate. " +
            "Looks like you've got plenty of time!"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)    }
    

    
    
    
    func beaconManager(manager: AnyObject, monitoringDidFailForRegion region: CLBeaconRegion?, withError error: NSError) {
        //print(error)
    }
}
