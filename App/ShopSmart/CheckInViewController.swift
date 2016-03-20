

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
    @IBOutlet var myLocationView: EILIndoorLocationView!
    
    // var beaconArray = [AnyObject].self
    
    /* Changes to range beacons*/
    
    let beaconManager = ESTBeaconManager()
  //  let beaconRegion = CLBeaconRegion(
       // proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        //identifier: "ranged region")
    
    
    
    let placesByBeacons = [
        
        /* "16358:55174": [
        "Produce Aisle": 1, // read as: it's 50 meters from
        "Dairy Aisle": 3,
        "Baked Goods Aisle": 20
        ],*/
        
        
        "63324:11566": [
            "Produce Aisle": 1, // read as: it's 50 meters from
            "Dairy Aisle": 3,
            "Baked Goods Aisle": 20
        ],
        
        
        "51899:16385": [
            
            "Produce Aisle": 8, // read as: it's 50 meters from
            "Dairy Aisle": 1,
            "Baked Goods Aisle": 7
        ],
        
        "18138:11207": [
            "Produce Aisle": 18, // read as: it's 50 meters from
            "Dairy Aisle": 4,
            "Baked Goods Aisle": 1 ]
    ]
    
    
    
    //Menu
    
    
    
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
                
                var beaconArr = self.location.beacons;
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
        
       
       // self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        
        //self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    
   /* func placesNearBeacon(beacon: CLBeacon) -> [String] {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let places = self.placesByBeacons[beaconKey] {
            let sortedPlaces = Array(places).sort { $0.1 < $1.1 }.map { $0.0 }
            return sortedPlaces
        }
        return []
    }
    
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon],
        inRegion region: CLBeaconRegion) {
            if let nearestBeacon = beacons.first {
                let places = placesNearBeacon(nearestBeacon)
                // TODO: update the UI here
                
            }
    }*/
    
    
    
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }*/

    
    
    
    func beaconManager(manager: AnyObject, monitoringDidFailForRegion region: CLBeaconRegion?, withError error: NSError) {
        //print(error)
    }
}
