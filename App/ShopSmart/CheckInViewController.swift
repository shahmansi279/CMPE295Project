

//
//  CheckInViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/19/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire


class CheckInViewController: UIViewController,EILIndoorLocationManagerDelegate ,ESTBeaconManagerDelegate{
    
    
    /* Indoor Map Params */
    
    @IBOutlet var myPosLabel: UILabel!
    let locationManager : EILIndoorLocationManager  = EILIndoorLocationManager()
    var location: EILLocation!
    var sensors : [Sensor] = []
    @IBOutlet var myLocationView: EILIndoorLocationView!
    
    var ListArray=[List]()
    var notificationItem = [String:String]()
    
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
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let list_id = prefs.valueForKey("list_id") as! Int
        
        fetchUserShoppingList(list_id);
        
        fetchBeaconsofInterest(list_id);
        
        
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
      
            
        
        
        

        
        let labelArr = ["Produce","Dairy", "Baked Goods","Health" , "Beverages"]
        
        // You will find the identifier on https://cloud.estimote.com/#/locations
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "smart-store")
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
                
                }
            
            else {
                print("can't fetch location: \(error)")
            }

        
        
        
        }
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchUserShoppingList(list_id:Int){
    
        
        Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/userlistdetail/\(list_id)/?format=json")
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    print("Success: \(JSON)")
                    self.populateListData(JSON as! NSArray)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }

    }
   
    
    func updateNotificationList(){
    
    
    
        for list in self.ListArray{
            
            if(notificationItem[list.productCategory!]==nil)
            {
                notificationItem[list.productCategory!] = list.productTitle
            }
            else{
            
                var newVal = notificationItem[list.productCategory!]! + " , "
                newVal += list.productTitle!
                
               notificationItem[list.productCategory!] = newVal
            
            }
        }
        
        print("NF")
        print(notificationItem)
    
    }
    
    func fetchBeaconsofInterest(list_id: Int)  {
    
        
        
        Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/sensors_of_interest/?list_id=\(list_id)")
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    
                    self.populateData(JSON as! NSArray)
                    self.startSensorRanging()
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }

    }
    
    func populateData(jsonData: NSArray){
        
        if(jsonData.count>0){
            
            for item in jsonData{
                
                let dict = item[0] as! NSMutableDictionary
                let sensor = Sensor(data: dict)
                self.sensors.append(sensor)
                
            }
            
            
            
            
        }
        
    }
    

    
    
    func populateListData(jsonData: NSArray){
        
        if(jsonData.count>0){
            
            for item in jsonData{
                
                let dict = item as! NSMutableDictionary
                let listItem = List(data: dict)
                self.ListArray.append(listItem)
                
                
            }
        }
        
        updateNotificationList();

        
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
        
       
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.locationManager.stopMonitoringForLocation(location)
       // stopSensorMonitoring()
        stopSensorRanging()
        
        
        
        
    }
    
    
//Beacon monitoring
    
    
    func startSensorMonitoring(){
        
        if(self.sensors.count>0){
            
            
            for sensor in self.sensors {
                
                let br = CLBeaconRegion(proximityUUID: NSUUID( UUIDString: sensor.sensorUUID!)!, major:  sensor.sensorMajor!, minor: ((sensor.sensorMinor!)), identifier:(sensor.sensorDesc!))
                
                self.beaconManager.startMonitoringForRegion(br)
                
                print ("Started Region Monitoring for beacon" +  sensor.sensorTag!)
                
                
            }
            
            
        }
        
        
    }
    
    func stopSensorMonitoring(){
        
        if(self.sensors.count>0){
            
            
            for sensor in self.sensors {
                
                let br = CLBeaconRegion(proximityUUID: NSUUID( UUIDString: sensor.sensorUUID!)!, major:  sensor.sensorMajor!, minor: ((sensor.sensorMinor!)), identifier: sensor.sensorName!)
                
                self.beaconManager.stopMonitoringForRegion(br)
                
                print ("Stopped Region Monitoring for beacon - " +  sensor.sensorTag!)
                
                
            }
            
            
        }
        
        
    }

    
    
  /*func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        
        let notification = UILocalNotification()
    
    
        var note = "Go and Grab " + notificationItem[region.identifier]!
        note += " that is on your shopping list"
        notification.alertBody = note
         
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    
    
    }
    
    func beaconManager(manager: AnyObject,
        didExitRegion region: CLBeaconRegion) {
            
            print("Exit");
        /*    let notification = UILocalNotification()
            notification.alertBody =
                "Exit Event - Your gate closes in 47 minutes. " +
                "Current security wait time is 15 minutes, " +
                "and it's a 5 minute walk from security to the gate. " +
            "Looks like you've got plenty of time!"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification) 
            }
    */
    }
    
    
    
    func beaconManager(manager: AnyObject, monitoringDidFailForRegion region: CLBeaconRegion?, withError error: NSError) {
        print(error)
    }
    
    
    */
    
    
    //Beacon Ranging  -- Start
    
    
    let placesByBeacons = [
        
        //Produce
        "16358:55174": [
            "Produce": 0, // read as: it's 50 meters from
            // "Heavenly Sandwiches" to the beacon with
            // major 6574 and minor 54631
            "Green & Green Salads": 150,
            "Mini Panini": 325
        ],
        
        
        //Dairy
        
        
        
           ]
    let sensorArr = [51899:"Beverages-Mint",57568:"Canned Foods-Ice",16358:"Produce -BB",34611:"Baked Goods -Ice",63324:"Frozen Foods- BB",18138:"Dairy- Mint"]

    
    
    func startSensorRanging(){
        
        if(self.sensors.count>0){
            
            
            for sensor in self.sensors {
                
                let br = CLBeaconRegion(proximityUUID: NSUUID( UUIDString: sensor.sensorUUID!)!, major:  sensor.sensorMajor!, minor: ((sensor.sensorMinor!)), identifier:(sensor.sensorDesc!))
                
                self.beaconManager.startRangingBeaconsInRegion(br)
                print ("Started Region Ranging for beacon" +  sensor.sensorTag!)
                
                
            }
            
            
        }
        
        
    }
    
    
    func stopSensorRanging(){
        
        if(self.sensors.count>0){
            
            
            for sensor in self.sensors {
                
                let br = CLBeaconRegion(proximityUUID: NSUUID( UUIDString: sensor.sensorUUID!)!, major:  sensor.sensorMajor!, minor: ((sensor.sensorMinor!)), identifier: sensor.sensorName!)
                
                self.beaconManager.stopRangingBeaconsInRegion(br)
                print ("Stopped Region Ranging for beacon - " +  sensor.sensorTag!)
                
                
            }
            
            
        }
        
        
    }
    
    
 /*   func placesNearBeacon(beacon: CLBeacon) -> [String] {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let places = self.placesByBeacons[beaconKey] {
            let sortedPlaces = Array(places).sorted { $0.1 < $1.1 }.map { $0.0 }
            return sortedPlaces
        }
        return []
    }*/
    
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon],
        inRegion region: CLBeaconRegion) {
           
           
            if var nearestBeacon = beacons.first {
                
               // print nearestBeacon.accuracy
              //  let places = placesNearBeacon(nearestBeacon)
                // TODO: update the UI here
                
                if(nearestBeacon.accuracy<1.0 && nearestBeacon.accuracy>0)
                {
                
                print(sensorArr[Int(nearestBeacon.major)] );
                print (nearestBeacon.accuracy)
                    let notification = UILocalNotification()
                    
                    
                    var note = "Go and Grab " + notificationItem[region.identifier]!
                    note += " that is on your shopping list"
                    notification.alertBody = note
                    
                    UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                    

                self.beaconManager.stopRangingBeaconsInRegion(region)
                
                }
                    //TODO: remove after implementing the UI
            }
    }

}
