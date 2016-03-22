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
        
        //Add the pan gesture to the view.
        
      //  self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        // Do any additional setup after loading the view.
        
        load()
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("isLoggedIn") as Int
        
      /*  if (isLoggedIn != 1){
            
            addToCartOutlet.hidden = true
            addToListOutlet.hidden = true
            
        }*/
        
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
        alert.addAction(UIAlertAction(title: "ADD", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let quantity = Int(textField.text!)
            print(quantity)
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let cart_id:Int = prefs.integerForKey("cart_id") as Int
            let params = ["cart_id":cart_id, "product_id":self.product.productId, "product_qty":quantity!, "cart_prd_attr1":self.product.productTitle!, "cart_prd_attr2":self.product.productCost!] as Dictionary<String, AnyObject>
            let headers = [
                "Content-Type": "application/json"
            ]
            
            
            Alamofire.request(.POST, "http://127.0.0.1:8000/smartretailapp/api/cartprd/", headers: headers, parameters: params, encoding:  .JSON)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .Success(let responseContent):
                        // Handle success case...
                        print("Success: \(responseContent)")
                        let alert = UIAlertController(title: "Success!", message:"Product has been added to the Shopping Cart", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default) { _ in}
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
            
            
        }))

        let cancel = UIAlertAction(title: "CANCEL", style: .Default) { _ in}
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true){}
        
        
    }
    
    
    @IBAction func AddToListBtn(sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Add to List", message:"Enter Quantity", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Enter Quantity"
        })
        alert.addAction(UIAlertAction(title: "ADD", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let quantity = Int(textField.text!)
            print(quantity)
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let list_id:Int = prefs.integerForKey("list_id") as Int
            
            let params = ["list_id":list_id, "product_id":self.product.productId, "product_qty":quantity!, "list_prd_attr1":self.product.productTitle!] as Dictionary<String, AnyObject>
            
            let headers = [
                "Content-Type": "application/json"
            ]
            
            
            Alamofire.request(.POST, "http://127.0.0.1:8000/smartretailapp/api/listprd/", headers: headers, parameters: params, encoding:  .JSON)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .Success(let responseContent):
                        // Handle success case...
                        print("Success: \(responseContent)")
                        let alert = UIAlertController(title: "Success!", message:"Product has been added to the Shopping List", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default) { _ in}
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
            
        }))
        
        let cancel = UIAlertAction(title: "CANCEL", style: .Default) { _ in}
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true){}
        
        
    }
    
    
    
}








