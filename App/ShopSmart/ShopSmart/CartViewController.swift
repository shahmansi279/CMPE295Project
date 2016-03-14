//
//  CartViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/27/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class CartViewController: UIViewController {

    @IBOutlet weak var Menu: UIBarButtonItem!{
    
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
    
    }
    
    
    
    @IBOutlet weak var unavailableCartLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Add the pan gesture to the view.

        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        //self.cartTableView.delegate=self
        //self.cartTableView.dataSource=self
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("isLoggedIn") as Int
        
        if (isLoggedIn != 1){
            unavailableCartLabel.text = "Cart Unavailable! Please Log in."
            
        } else {
        
            let cart_id = prefs.valueForKey("cart_id") as! Int
            
            Alamofire.request(.GET, "http://127.0.0.1:8000/smartretailapp/api/usercartdetail/\(cart_id)/?format=json")
                .responseJSON {  response in
                    switch response.result {
                    case .Success(let JSON):
                        //self.populateData(JSON as! NSMutableArray)
                        print("Success: \(JSON)")
                        
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
            }
            
            
            
            
        }
        
       

        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
