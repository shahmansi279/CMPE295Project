//
//  ProductsViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/22/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit

class ProductsViewController: UICollectionViewController {

    
    
    var classArr=["Category1","Category2"]
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
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    
        return classArr.count;
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
       
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier( "cat", forIndexPath: indexPath)
        
        // "\(classArr[indexPath.row])"
        
        return cell
    
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        
        return 1;
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
