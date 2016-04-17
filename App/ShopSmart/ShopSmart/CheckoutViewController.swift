//
//  CheckoutViewController.swift
//  ShopSmart
//
//  Created by Jessie Deot on 3/31/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class CheckoutViewController: UIViewController {

    var subtotal:Float = 0.0
    var total:Float = 0.0
    var discount:Float = 0.0
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var offerField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        subtotalLabel.text = "\(subtotal)"
        totalLabel.text = "\(subtotal)"
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    @IBAction func AddOfferBtn(sender: UIButton) {
        
        let offerCode = offerField.text!
        
        if ( offerCode == "") {
            
            let alert = UIAlertController(title: "Failed!", message:"Please enter a valid Offer Code", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        } else {
            
            Alamofire.request(.GET, "\(Constant.baseURL)/smartretailapp/api/offercode/?offercode=\(offerCode)")
                .responseJSON {  response in
                    switch response.result {
                    case .Success(let JSON):
                        print("Success: \(JSON.count)")
                        if ((JSON.count) != 0) {
                            let discount = JSON[0][0] as! Float
                            self.total = self.subtotal - ((discount/100) * self.subtotal)
                            print("Total: \(self.total)")
                            self.totalLabel.text = String(format:"%.2f", self.total)
                            
                        } else {
                            
                            print ("Not a valid offer code")
                            let alert = UIAlertController(title: "Failed!", message:"The offer code is invalid", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true){}
                        }
                        
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
            }
            
        }
        
    }
    
    @IBAction func PayBtn(sender: UIButton) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let user_id: Int = prefs.valueForKey("id") as! Int
        let cart_id: Int = prefs.integerForKey("cart_id") as Int
        let csrftoken = prefs.objectForKey("csrftoken") as! String
        
        let params = ["cart_status":"processed","cart_customer_id":user_id] as Dictionary<String, AnyObject>
        let headers = [ "Accept":"application/json" ,  "Content-Type": "application/json" , "X-CSRFToken" : csrftoken]
        
        Alamofire.request(.PUT, "\(Constant.baseURL)/smartretailapp/api/cart/\(cart_id)/", headers: headers, parameters: params, encoding:  .JSON)
            .validate()
            .responseJSON {  response in
                switch response.result {
                case .Success:
                    print("Payment Successful")
                    self.fetchCart()
                    let alert = UIAlertController(title: "Success!", message:"Payment Successful", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: {
                        [unowned self] (action) -> Void in
                        self.performSegueWithIdentifier("checkout_done", sender: self)
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true){}
                    //self.fetchCart()
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }

    }
    
    func fetchCart(){
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let id = prefs.valueForKey("id") as! Int
        print("User ID: \(id)")
        Alamofire.request(.GET, "\(Constant.baseURL)/smartretailapp/api/usercart/?cart_customer_id=\(id)/")
            .responseJSON {  response in
                print("original URL request: \(response.request)")  // original URL request
                print("URL response: \(response.response)") // URL response
                print("server data: \(response.data)")     // server data
                print("response result: \(response.result)")
                switch response.result {
                case .Success(let JSON):
                    print(JSON[0][0])
                    let cart_id = JSON[0][0] as! Int
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(cart_id, forKey: "cart_id")
                    prefs.synchronize()
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
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
