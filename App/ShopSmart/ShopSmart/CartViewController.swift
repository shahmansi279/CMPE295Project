//
//  CartViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/27/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var Menu: UIBarButtonItem!{
    
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Add the pan gesture to the view.

        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
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
