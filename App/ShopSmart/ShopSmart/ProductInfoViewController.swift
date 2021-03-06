//
//  ProductInfoViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/7/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import Foundation
import Alamofire


class ProductInfoViewController : UIViewController {
    
    var product: Product!
    //var cookies : NSHTTPCookie!
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet weak var addToCartOutlet: UIButton!
    
    @IBOutlet weak var addToListOutlet: UIButton!
   
    @IBOutlet var prodCost: UILabel!
    @IBOutlet var prodTitle: UILabel!
    
    @IBOutlet var productDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
      //  let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
      //  view.addGestureRecognizer(tap)
        
        //Add the pan gesture to the view.
        
      //  self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        // Do any additional setup after loading the view.
        
        load()
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("isLoggedIn") as Int
        
        
       if (isLoggedIn != 1){
            
            addToCartOutlet.hidden = true
            addToListOutlet.hidden = true
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "whitebg.jpeg")!)
        productDesc.backgroundColor =  UIColor(patternImage: UIImage(named: "whitebg.jpeg")!)
       


    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func load(){
        
        let cost = String(product.productCost!)
        self.prodTitle.text=product.productTitle!
        self.productDesc.text=product.productDesc!
        self.prodCost.text=cost
        
        if(product.prodImgUrl != nil)
        
        {
        
            let url = NSURL(string: "\(product.prodImgUrl!)")
            let imageData: NSData = NSData(contentsOfURL: url!)!
        
            dispatch_async(dispatch_get_main_queue()){
            
            let bgImage = UIImage(data:imageData)
            
            self.imgView.image = bgImage
            
            
            }
        }
        
        else {
            self.imgView.image  = UIImage(named: "default")
        }
    }
    
    
    
    @IBAction func AddToCartBtn(sender: UIButton) {
        
        let alert = UIAlertController(title: "Add to Cart", message:"Enter Quantity", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Enter Quantity"
        })
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let quantity = Int(textField.text!)
            if quantity == nil{
                //String Entered as quantity
                let alert = UIAlertController(title: "Failed!", message:"Please enter a valid quantity", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
                
            } else {
                
                //Int Entered as quantity
                
                print(quantity)
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                let cart_id:Int = prefs.integerForKey("cart_id") as Int
                let params = ["cart_id":cart_id, "product_id":self.product.productId, "product_qty":quantity!, "cart_prd_attr1":self.product.productTitle!, "cart_prd_attr2":self.product.productCost!] as Dictionary<String, AnyObject>
                
                let csrftoken = prefs.objectForKey("csrftoken") as! String
                
                let headers = [ "Accept":"application/json" ,  "Content-Type": "application/json" , "X-CSRFToken" : csrftoken]
                
                Alamofire.request(.POST, "\(Constant.baseURL)/smartretailapp/api/cartprd/", headers: headers, parameters: params, encoding:  .JSON)
                    .validate()
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success(let responseContent):
                            // Handle success case...
                            print("Success: \(responseContent)")
                            let alert = UIAlertController(title: "Success!", message:"Product has been added to the Shopping Cart", preferredStyle: .Alert)
                            let action1 = UIAlertAction(title: "OK", style: .Default) { _ in}
                            alert.addAction(action1)
                            let action = UIAlertAction(title: "View Cart", style: .Default, handler: {
                                [unowned self] (action) -> Void in
                                self.performSegueWithIdentifier("addToCart_done", sender: self)
                                })
                            alert.addAction(action)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(alert, animated: true){}
                            })
                            break
                        case .Failure(let error):
                            // Handle failure case...
                            print("Request failed with error: \(error)")
                            break
                        }
                }
            }
            
                
        }))
            
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { _ in}
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true){}
        
    }
    
    
    @IBAction func AddToListBtn(sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Add to List", message:"Enter Quantity", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Enter Quantity"
        })
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let quantity = Int(textField.text!)
            if quantity == nil{
                //String Entered as quantity
                let alert = UIAlertController(title: "Failed!", message:"Please enter a valid quantity", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
                
            } else {
                
                //Int Entered as quantity
                print(quantity)
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                let list_id:Int = prefs.integerForKey("list_id") as Int
                
                let params = ["list_id":list_id, "product_id":self.product.productId, "product_qty":quantity!, "list_prd_attr1":self.product.productTitle!, "list_prd_attr2":self.product.productDept!] as Dictionary<String, AnyObject>
                
                let csrftoken = prefs.objectForKey("csrftoken") as! String
                
                let headers = ["Accept":"application/json" ,  "Content-Type": "application/json" , "X-CSRFToken" : csrftoken]
                
                Alamofire.request(.POST, "\(Constant.baseURL)/smartretailapp/api/listprd/",parameters: params,  encoding: .JSON , headers:headers)
                    .responseJSON { response in
                        
                        
                        switch response.result {
                        case .Success(let responseContent):
                            // Handle success case...
                            print("Success: \(responseContent)")
                            let alert = UIAlertController(title: "Success!", message:"Product has been added to the Shopping List", preferredStyle: .Alert)
                            let action1 = UIAlertAction(title: "OK", style: .Default) { _ in}
                            alert.addAction(action1)
                            let action = UIAlertAction(title: "View List", style: .Default, handler: {
                                [unowned self] (action) -> Void in
                                self.performSegueWithIdentifier("addToList_done", sender: self)
                                })
                            alert.addAction(action)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(alert, animated: true){}
                            })
                            break
                        case .Failure(let error):
                            // Handle failure case...
                            print("Request failed with error: \(error)")
                            break
                        }
                }

                
            }
            
            
        }))
        
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { _ in}
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true){}
    }
    
}









