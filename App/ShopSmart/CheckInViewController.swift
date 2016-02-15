

//
//  CheckInViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/19/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController,EILIndoorLocationManagerDelegate {
    
    @IBOutlet weak var myLocationView: EILIndoorLocationView!
     @IBOutlet weak var myLabel: UILabel!
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    
    
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
        
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "mansi-home")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if location != nil {
                self.location = location!
                self.locationManager.startPositionUpdatesForLocation(self.location)
                self.myLocationView.drawLocation(location)
                self.myLocationView.showTrace=true
                self.myLocationView.traceColor=UIColor.yellowColor()
            } else {
                print("can't fetch location: \(error)")
            }
        }
        
        
        //
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
       
        
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
            var accuracy: String!
            switch positionAccuracy {
            case .VeryHigh: accuracy = "+/- 1.00m"
            case .High:     accuracy = "+/- 1.62m"
            case .Medium:   accuracy = "+/- 2.62m"
            case .Low:      accuracy = "+/- 4.24m"
            case .VeryLow:  accuracy = "+/- ? :-("
            }
            print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
                position.x, position.y, position.orientation, accuracy))
            
            myLocationView.updatePosition(position)
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
