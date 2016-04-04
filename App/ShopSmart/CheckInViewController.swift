

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
    
    let sensorArr = [51899:"Beverages-Mint",57568:"Canned Foods-Ice",16358:"Produce -BB",34611:"Baked Goods -Ice",63324:"Frozen Foods- BB",18138:"Dairy- Mint"]
    
    let sensorLblArr = [51899:"Beverages",57568:"Canned Foods",16358:"Produce",34611:"Baked Goods",63324:"Frozen Foods",18138:"Dairy"]
    
    let aisleX = [51899:8.5, 16358:5.0, 34611:1.0, 63324:9.0, 18138:6.0]
    let aisleY = [51899:-5.0, 16358:-1.0, 34611:-2.0, 63324:-1.0, 18138:-5.0]
    
    let aisleLblX = [51899:10.5, 16358:5.0, 34611:3.0, 63324:9.0, 18138:8.5]
    let aisleLblY = [51899:-7.0, 16358:1.0, 34611:-4.0, 63324:1.0, 18138:-7.0]

    
    
    let imgArr = [51899:"beverages.jpg",16358:"produce.jpg",34611:"baked_goods.jpg",63324:"frozenfood.jpg",18138:"dairy.jpg"]
    
    
    let sensorIdArr = ["e0d44001cabb":"Beverages-Mint","ead68aabe0e0":"Canned Foods-Ice","ee61d7863fe6":"Produce -BB","e228a6bc8733":"Baked Goods -Ice","e97e2d2ef75c":"Frozen Foods- BB","d7b72bc746da":"Dairy- Mint"]
    
    
    
    
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
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "smart-grocery-store")
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
                    
                  //  var modestOrientedPointorentation = EILOrientedPoint.init(x: estOrientedPointorentation.x  , y: estOrientedPointorentation.y - 1.0 , orientation: estOrientedPointorentation.orientation)
                    
                    
                    
                    var modestOrientedPointorentation = EILOrientedPoint.init(x: self.aisleLblX[Int(beacon.major!!.description)!]!, y:self.aisleLblY[Int(beacon.major!!.description)!]!, orientation: 0)
                    
                    var label1 = UILabel.init(frame: CGRectMake(0, 0, 150, 40))
                    
                    
                    label1.text = self.sensorLblArr[Int(beacon.major!!.description)!]
                    label1.font = UIFont.init(name: "Arial", size: 9.0)
                    
                    var id = labelArr[i]
                    
                    self.myLocationView.drawObjectInBackground(label1, withPosition: modestOrientedPointorentation, identifier: id)
                    
                    //Changes for Image Object
                    
                    
                    var imageViewObject :UIImageView
                    
                    imageViewObject = UIImageView(frame:CGRectMake(0, 0, 60, 40))
                    
                    let imgName = self.imgArr[Int(beacon.major!!.description)!]
                    
                    imageViewObject.image = UIImage(named:imgName!)
                    
                    
                    var id_img = labelArr[i++] + "img"
                    
                    var imgOrientedPointorentation = EILOrientedPoint.init(x: self.aisleX[Int(beacon.major!!.description)!]!, y:self.aisleY[Int(beacon.major!!.description)!]!, orientation: 0)
                    
                    
                     self.myLocationView.drawObjectInBackground(imageViewObject, withPosition:imgOrientedPointorentation , identifier:id_img )
                    
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
        
        
        Alamofire.request(.GET, "\(Constant.baseURL)/smartretailapp/api/userlistdetail/\(list_id)/?format=json")
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
        
        
        
        Alamofire.request(.GET, "\(Constant.baseURL)/smartretailapp/api/sensors_of_interest/?list_id=\(list_id)")
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
    
    /*
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
    
    */
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
    
        print("Enter")
    
    }
    
    func beaconManager(manager: AnyObject,
    didExitRegion region: CLBeaconRegion) {
    
        print("Exit");
     
    }

    
    
    
   /*
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
                
                //  let places = placesNearBeacon(nearestBeacon)
                // TODO: update the UI here
                
                if(nearestBeacon.accuracy<1.0 && nearestBeacon.accuracy>0)
                {
                    
                    print(sensorArr[Int(nearestBeacon.major)]);
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
