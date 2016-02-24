//
//  ViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/9/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var data: [String] = []
    
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
        Alamofire.request(.GET, "http://127.0.0.1:8000/smartretailapp/api/offer/?format=json")
            .responseJSON {response in
                
                let jsonArray = response.result.value as! NSMutableArray
                for item in jsonArray{
                    
                    let dict = item as! NSMutableDictionary
                    
                    let url = dict["offer_img_url"] as? String
                    
                    self.data.append(url!)
                    
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
        
        
        let url = NSURL(string: "\(self.data[indexPath.row])")
        let imageData: NSData = NSData(contentsOfURL: url!)!
        
        
        dispatch_async(dispatch_get_main_queue()){
            
            let bgImage = UIImage(data:imageData)
            
            
            cell.imgView.image = bgImage
            
            
            
        }
        
        return cell
        
        
    }
}
