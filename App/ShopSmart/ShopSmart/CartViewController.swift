//
//  CartViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/27/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var Menu: UIBarButtonItem!{
    
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
    
    }
    
    
    
    @IBOutlet weak var unavailableCartLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var checkoutOutlet: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    var CartArray=[Cart]()
    var total:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Add the pan gesture to the view.
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        self.cartTableView.delegate=self
        self.cartTableView.dataSource=self
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("isLoggedIn") as Int
        
        
        if (isLoggedIn != 1){
            unavailableCartLabel.text = "Cart Unavailable! Please Log in."
            checkoutOutlet.hidden = true
            
        } else {
            
            let cart_id = prefs.valueForKey("cart_id") as! Int
            print(cart_id)
            Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/usercartdetail/\(cart_id)/?format=json")
                .responseJSON {  response in
                    switch response.result {
                    case .Success(let JSON):
                        print("Success: \(JSON)")
                        self.populateData(JSON as! NSArray)
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
            }
        }
    }
    
    
    
    func populateData(jsonData: NSArray){
        
        if(jsonData.count>0){
            
            for item in jsonData{
                
                let dict = item as! NSMutableDictionary
                let cartItem = Cart(data: dict)
                self.CartArray.append(cartItem)
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.cartTableView.reloadData()
                
                
            };
            
        }
        
    }
    
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CartArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cart = self.cartTableView.dequeueReusableCellWithIdentifier("Cart", forIndexPath: indexPath) as! CartTableViewCell
        
        Cart.cartLabel.text = CartArray[indexPath.row].productTitle
        let qty:Int = (CartArray[indexPath.row].productQty!) as Int
        Cart.qtyLabel.text = String(qty)
        Cart.priceLabel.text = CartArray[indexPath.row].productCost
        
        if let floatVersion:Float = (CartArray[indexPath.row].productCost! as NSString).floatValue {
            let productPrice = Float(qty) * floatVersion
            let multipliedString = "\(productPrice)"
            //print("price: \(productPrice)")
            Cart.mulPriceLabel.text = multipliedString
            total = total + productPrice
            //print(total)
            totalLabel.text = "\(total)"
        }

        
        return Cart
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //let indexPath = self.depttableView.indexPathForCell(sender as! TableViewCell)
        let subtotal = self.total
        let dvc = segue.destinationViewController as! CheckoutViewController
        dvc.subtotal = subtotal
        
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
