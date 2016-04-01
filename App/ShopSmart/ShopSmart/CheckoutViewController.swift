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
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var offerField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        subtotalLabel.text = "\(subtotal)"
        totalLabel.text = "\(subtotal)"
        
    }
    
    
    @IBAction func AddOfferBtn(sender: UIButton) {
        
        let offerCode = offerField.text!
        
        if ( offerCode == "") {
            
            let alert = UIAlertController(title: "Failed!", message:"Please enter a valid Offer Code", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        } else {
            
            Alamofire.request(.GET, "http://127.0.0.1:8000/smartretailapp/api/offercode/\(offerCode)/?format=json")
                .responseJSON {  response in
                    switch response.result {
                    case .Success(let JSON):
                        print("Success: \(JSON)")
                        //self.populateData(JSON as! NSArray)
                        
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
        
        Alamofire.request(.PUT, "http://127.0.0.1:8000/smartretailapp/api/cart/\(cart_id)/", headers: headers, parameters: params, encoding:  .JSON)
            .validate()
            .responseJSON {  response in
                switch response.result {
                case .Success:
                    print("Update Successful")
                    let alert = UIAlertController(title: "Success!", message:"Payment Successful", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true){}
                    
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
