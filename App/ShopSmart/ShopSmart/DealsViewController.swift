//
//  DealsViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 2/16/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit

class DealsViewController: UITableViewController {
    
    var offerArray = ["offer1"]
    

    
    @IBOutlet var Menu: UIBarButtonItem!{
        
        
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //offers = fetchOffers();
        
        
              //Add the pan gesture to the view.
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return offerArray.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = offerArray[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(offerArray[indexPath.row])"
        
        return cell
        
    }
    
    
    func fetchOffers()-> NSArray {
        
        
        
        
        
        return offerArray
    }
    
    
    
}
