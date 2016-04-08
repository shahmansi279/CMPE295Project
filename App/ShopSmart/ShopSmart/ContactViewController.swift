//
//  ContactViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/19/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ContactViewController: UIViewController {

    @IBOutlet var Menu: UIBarButtonItem!{
    
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
        

    }
    var store : Store?
    
    var storeAddress : String?
    
    
    @IBOutlet var storeWebsite: UILabel!
    
    @IBOutlet var storeAddr: UILabel!
    
 
    
    @IBOutlet var storeEmail: UILabel!
    
    
    @IBOutlet var storePhone: UILabel!
 
    @IBOutlet var storeName: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the pan gesture to the view.
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());


        // Do any additional setup after loading the view.
        
        loadData()
        
     
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "whitebg.jpeg")!)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadData(){
    
        Alamofire.request(.GET, "\(Constant.baseURL)/smartretailapp/api/store/1")
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    self.populateData(JSON as! NSDictionary)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }

    
    
    }
    
    func populateData(jsonData : NSDictionary){
    
            self.store = Store(data: jsonData)
            
            self.storeAddress = store!.storeAddress
                
                
        
            
            dispatch_async(dispatch_get_main_queue()) {
                
                
                self.storeAddr.text = self.store!.storeAddress
                self.storeName.text = self.store!.storeDesc
                self.storePhone.text = self.store!.storeContact
                self.storeEmail.text = self.store!.storeEmail
                self.storeWebsite.text = self.store!.storeWebsite
                self.populateMap(self.storeAddress!)
                
            };
        }
        
    func  populateMap (storeAddress:String){
        
        
            var geocoder: CLGeocoder = CLGeocoder()
            geocoder.geocodeAddressString(storeAddress,completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if (placemarks?.count > 0) {
                    var topResult: CLPlacemark = (placemarks?[0])!
                    var placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                    var region: MKCoordinateRegion = self.mapView.region
                    
                    region.center = placemark.coordinate
                    
                    region.span = MKCoordinateSpanMake(0.5, 0.5)
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(placemark)
                }
            })
            
            
            
        }
        
    
}
