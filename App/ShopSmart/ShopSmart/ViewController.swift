
//
//  ViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/9/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate {
    
    var data: [Offer] = []
    
    var location: NSString?
    var manager:CLLocationManager!
    var userLocationZipCode:String?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var Menu: UIBarButtonItem!{
        
        
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the pan gesture to the view.
        self.collectionView.delegate=self
        self.collectionView.dataSource=self
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        // Do any additional setup after loading the view, typically from a nib.
    
        
        //Fetch the location authorization
        requestLocationAuthorization()

        
        
        //Fetch the data from Smart Retail Service
        loadData()
        
        
    }
    
    /* Request Location Authorization from the User */
    
    func requestLocationAuthorization(){
        
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    /* Check Location Authorization Status */
    
    func checkLocationServiceStatus() -> Bool {
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
                
            case .NotDetermined, .Restricted, .Denied:
                return false
                
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                
                return true
                
            default:
                return false
            }
        }
        else {
            
            return false
        }
    }
    
    /*On Location Authorization Status Event Change */
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if(checkLocationServiceStatus()){
            //If user allows access to location services
            print ("Location service enabled")
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()}
            
        else {
            
            //if user does not allow access
            print ("Location service disabled")
            
            
        }
        
    }
    

       /* fetch the user location */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if (placemarks!.count > 0 ){
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    func displayLocationInfo(placemark: CLPlacemark!) {
        if placemark != nil {
            //stop updating location to save battery life
            manager.stopUpdatingLocation()
            self.userLocationZipCode = placemark.postalCode
            
            self.collectionView.reloadData()
            
            /*print(placemark.locality)
            print(placemark.postalCode)
            print(placemark.administrativeArea)
            print(placemark.country)
            print (placemark.subLocality)
            print (placemark.areasOfInterest)*/
            
           
        }
        
    }

    
    
    func loadData(){
        
        if(self.userLocationZipCode != nil)
    
        {
            
            let url = "http://54.153.9.205:8000/smartretailapp/api/offernearby/" + self.userLocationZipCode!;
            
            let mod_url = url + "?format=json"
            
            
            Alamofire.request(.GET, mod_url)
                .responseJSON {  response in
                    switch response.result {
                    case .Success(let JSON):
                        self.populateData(JSON as! NSMutableArray)
                        
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
            }

            
        }
        
        else{
        
        
           
           // Alamofire.request(.GET, "http://127.0.0.1:8000/smartretailapp/api/offer/?
            Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/offer/?format=json")
                .responseJSON {  response in
                    switch response.result {
                    case .Success(let JSON):
                        self.populateData(JSON as! NSMutableArray)
                        
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
            }

        
        }
    }
    
    
    
    func populateData(jsonData: NSMutableArray){
        
        if(jsonData.count>0){
            
            // let jsonArray = response.result.value as! NSMutableArray
            for item in jsonData{
                
                let dict = item as! NSMutableDictionary
                
               // let url = dict["offer_img_url"] as? String
               
                let offerItem = Offer(data: dict)
                self.data.append(offerItem)
             
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.collectionView.reloadData()
                
                
            };
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Collection View methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        print(self.data.count)
        return self.data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! CollectionViewCell
        
        //cell.contentView.frame = cell.bounds
        //cell.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let url = NSURL(string: "\(self.data[indexPath.row].offerImgUrl)")
        
        let imageData: NSData = NSData(contentsOfURL: (url!))!
        
        
        dispatch_async(dispatch_get_main_queue()){
            
            let bgImage = UIImage(data:imageData)
            
            cell.imgView.image = bgImage
            
            
        }
        
        return cell
        
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if(segue.identifier == "offer_detail"){
            let indexPath = self.collectionView.indexPathForCell(sender as! CollectionViewCell)
            let offer = self.data[indexPath!.row]
         
            let dvc = segue.destinationViewController as! OfferDetailViewController
            
      
            dvc.offer = offer
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
       
        /*let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        var size = flowLayout.itemSize ;
        
        size.height = size.height * 2;
        
        return size;*/
        
        return CGSize(width: collectionView.frame.size.width/1.5, height: 200)
    }

}
