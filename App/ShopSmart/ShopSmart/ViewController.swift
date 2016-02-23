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
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request(.GET, "http://127.0.0.1:8000/smartretailapp/api/offer/?format=json")
            .responseJSON {response in
                
                let jsonArray = response.result.value as! NSMutableArray
                for item in jsonArray{
                    
                    let dict = item as! NSMutableDictionary
                    
                    let url = dict["offer_img_url"] as? String
                    
                    
                    self.data.append(url! as String)
                    
                    
                    
                }
        }
        print(self.data)
        
        collectionView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Collection View methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! CollectionViewCell
        
        
        
        let url = NSURL(string: "\(data[indexPath.row])")
        print(url)
        
        let imageData: NSData = NSData(contentsOfURL: url!)!
        let bgImage = UIImage(data:imageData)
        
        cell.imgView.image = bgImage
        
        // cell.imgView.image = UIImage(named: array[indexPath.row])
        
        
        
        return cell
    }
    
    
}

