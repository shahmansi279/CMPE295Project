

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
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    @IBOutlet var myLocationView: EILIndoorLocationView!
   // var beaconArray = [AnyObject].self
    
    /* Changes to range beacons*/
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "ranged region")
    
    
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
        
        
        ESTConfig.setupAppID("cmpe297-group5-shopsmart-c0f", andAppToken: "abb0580238d61d0abc69bf8e6204cfcb")
        
        self.locationManager.delegate = self
        
        
        let labelArr = ["Produce","Dairy", "Baked Goods","Health"]
        
        // You will find the identifier on https://cloud.estimote.com/#/locations
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "nthiagu-s-location-6xe")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if let location = location {
                
                self.location = location
                               self.myLocationView.drawLocation(location)
                
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
                    self.myLocationView.showTrace = true
                    self.myLocationView.traceColor = UIColor.greenColor()
                    self.myLocationView.rotateOnPositionUpdate = true

                }
                
                
                // You can configure the location view to your liking:
               // self.myLocationView.showTrace = true
                //self.myLocationView.rotateOnPositionUpdate = false
                // Consult the full list of properties on:
                // http://estimote.github.io/iOS-Indoor-SDK/Classes/EILIndoorLocationView.html
                
                self.locationManager.startPositionUpdatesForLocation(self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
        
        
        
        //Setting up ranging
        
      //  self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
      //  self.beaconManager.requestAlwaysAuthorization()
        
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
            
            
            
            
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.myLocationView.locationDrawn {
            
            //some setup
            
            self.myLocationView.showWallLengthLabels = true
            //self.myLocationView.showBeaconOrientation = true
           // self.myLocationView.positionView = self.positionView
            self.myLocationView.showTrace = true
            self.myLocationView.rotateOnPositionUpdate = true
            
        }

       // self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        
        //self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    
    func placesNearBeacon(beacon: CLBeacon) -> [String] {
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
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
