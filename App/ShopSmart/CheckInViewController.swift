

//
//  CheckInViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/19/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController,EILIndoorLocationManagerDelegate {
    
    @IBOutlet var myPosLabel: UILabel!
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    @IBOutlet var myLocationView: EILIndoorLocationView!
    
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
        ESTConfig.setupAppID("cmpe297-group5-shopsmart-c0f", andAppToken: "abb0580238d61d0abc69bf8e6204cfcb")
        
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "nthiagu-s-location-6xe")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if location != nil {
                self.location = location!
                print("Location \(self.location)")
                self.locationManager.startPositionUpdatesForLocation(self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
        
        
        //
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(self.location != nil)
        {
        self.myLocationView.backgroundColor=UIColor.clearColor()
        self.myLocationView.showTrace=true
        self.myLocationView.showWallLengthLabels=true
        self.myLocationView.rotateOnPositionUpdate=false
        self.myLocationView.locationBorderColor=UIColor.blackColor()
        self.myLocationView.locationBorderThickness=6
        self.myLocationView.doorColor=UIColor.brownColor()
        self.myLocationView.traceColor=UIColor.orangeColor()
        self.myLocationView.drawLocation(location)
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
