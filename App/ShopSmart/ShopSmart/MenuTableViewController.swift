//
//  MenuTableViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/19/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuArray =  ["Shop","Check in","Account","Contact" ,"List","Cart"]
    
    
    var menuImageArray = ["shopgreen.png","checkingreen.png","accountgreen.png","contactgreen.png" ,"listgreen.png","cartgreen.png"]
    

        
    
    override func viewDidLoad() {
        super.viewDidLoad()

           }
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
        
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuArray.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = menuArray[indexPath.row]
        
     
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        let image = "\(menuImageArray[indexPath.row])"
        let widthScale = cell.frame.size.width/500;
        let heightScale = cell.frame.size.height/80;
        //this line will do it!
        cell.imageView!.transform = CGAffineTransformMakeScale(widthScale, heightScale);

        
        cell.imageView?.image = UIImage(named :image);
        
        
        cell.textLabel?.text = "\(menuArray[indexPath.row])"
        
            /*  let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = UIColor.backgroundColorDark()
        cell.selectedBackgroundView = myCustomSelectionColorView
        cell.textLabel!.highlightedTextColor = UIColor.whiteColor()
*/
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
                      
       self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        
            let indexPath = tableView.indexPathForSelectedRow;
            let destViewController = segue.destinationViewController;
            destViewController.title = menuArray[indexPath!.row].capitalizedString
        
        
        
    }

   }
