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
        
        if (isLoggedIn != 1){
            
            addToCartOutlet.hidden = true
            addToListOutlet.hidden = true
            
        }
        
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
            
            //let param = ["cart_id" : [cart_id_st] , "cart_desc" : [cart_desc] , "product_id" : [prod_id_st] , "product_qty" : [qty_st]]
       
            /*
            Alamofire.request(.POST, "http://127.0.0.1:8000/smartretailapp/api/cartprd/", parameters: param, encoding:  .JSON)
                .validate()
                .responseJSON { [weak self] response in
                    
                    switch response.result {
                    case .Success(let responseContent):
                        print("Success: \(responseContent)")
                        break
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        break
                    }
            }
            */
            let urlPath = "http://54.153.9.205:8000/smartretailapp/api/cartprd/"
            print(urlPath)
            let params = ["cart_id":cart_id, "product_id":self.product.productId, "product_qty":quantity!, "cart_prd_attr1":self.product.productTitle!, "cart_prd_attr2":self.product.productCost!] as Dictionary<String, AnyObject>

            guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint");return }
            let request = NSMutableURLRequest(URL:endpoint)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.init(rawValue: 2))
                } catch {
                // Error Handling
                print("NSJSONSerialization Error")
                return
            }
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                do {
                    guard let dat = data else { throw JSONError.NoData }
                    guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                    print(json)
                    let alert = UIAlertController(title: "Success!", message:"Product has been added to the cart", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                    alert.addAction(action)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(alert, animated: true){}
                    })

                    
                } catch let error as JSONError {
                    print(error.rawValue)
                } catch {
                    print(error)
                }
                }.resume()
            
            
            
        }))

        let cancel = UIAlertAction(title: "CANCEL", style: .Default) { _ in}
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true){}
        
        
    }
    
}








