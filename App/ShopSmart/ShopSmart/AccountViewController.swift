//
//  AccountViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/19/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class AccountViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var cardNoField: UITextField!
    
    
    

    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }

    
   
    @IBAction func logoutBtn(sender: UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        
        self.performSegueWithIdentifier("goto_login", sender: self)
        
        
    }
    
    
    
    @IBOutlet var Menu: UIBarButtonItem!{
        
        
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }

    
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the pan gesture to the view.
           self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());

        // Do any additional setup after loading the view.
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("isLoggedIn") as Int
        
        if (isLoggedIn != 1){
            self.performSegueWithIdentifier("goto_login", sender: nil)
            
        } else {
            
            self.usernameField.text = prefs.valueForKey("username") as! String
            self.emailField.text = prefs.valueForKey("email") as! String
            let id = prefs.valueForKey("id") as! Int
            
            let urlPath = "http://54.153.9.205:8000/smartretailapp/api/customer/\(id)/?format=json"
            print(urlPath)
            guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint");return }
            let request = NSMutableURLRequest(URL:endpoint)
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                do {
                    guard let dat = data else { throw JSONError.NoData }
                    guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                    print(json)
                    
                    let addr = json["address1"] as? String
                    let zipcode = json["postal_code"] as? String
                    let phone = json["phone1"] as? String
                    let dob = json["birthdate"] as? String
                    let gender = json["gender"] as? String
                    let card = json["account_num"] as? Int
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        print("card: \(card)")
                        var cardString: String
                        if (card != nil){
                            cardString = String(card!)
                        } else {
                            cardString = ""
                        }
                        
                        self.addressField.text = addr
                        self.zipcodeField.text = zipcode
                        self.phoneField.text = phone
                        self.dobField.text = dob
                        self.genderField.text = gender
                        self.cardNoField.text = cardString
                        
                    })
                    
                } catch let error as JSONError {
                    print(error.rawValue)
                } catch {
                    print(error)
                }
                }.resume()
            
            self.fetchCart()
            self.fetchList()
        }
    }
    
    
    
    func fetchCart(){
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let id = prefs.valueForKey("id") as! Int
        
        Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/usercart/?cart_customer_id=\(id)/")
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    print(JSON[0][0])
                    let cart_id = JSON[0][0] as! Int
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(cart_id, forKey: "cart_id")
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }

    }

    func fetchList(){
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let id = prefs.valueForKey("id") as! Int
        
        Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/userlist/?list_customer_id=\(id)/")
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    print(JSON[0][0])
                    let list_id = JSON[0][0] as! Int
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(list_id, forKey: "list_id")
                    
                    
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
