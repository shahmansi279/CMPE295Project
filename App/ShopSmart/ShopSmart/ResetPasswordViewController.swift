//
//  ResetPasswordViewController.swift
//  ShopSmart
//
//  Created by Jessie Deot on 2/29/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
    

    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    
    
    
    @IBAction func resetBtn(sender: UIButton) {
        
        let usernameText = usernameField.text!
        let newPasswordText = newPasswordField.text!
        let verifyPasswordText = verifyPasswordField.text!
        
        
        
        if ( usernameText == "" || newPasswordText == "" || verifyPasswordText == "" ) {
            
            let alert = UIAlertController(title: "Failed!", message:"Please enter a valid Username and Password", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
            
        } else if (newPasswordText != verifyPasswordText) {
            let alert = UIAlertController(title: "Failed!", message:"The passwords do not match. Try again!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
            
        } else {
            
            let urlPath = "http://54.153.9.205:8000/smartretailapp/reset_password/?username=\(usernameText)&new_password=\(newPasswordText)"
            print(urlPath)
            
            guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint");return }
            let request = NSMutableURLRequest(URL:endpoint)
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                do {
                    guard let dat = data else { throw JSONError.NoData }
                    guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                    print(json["status"])
                    
                    let result = json["status"] as? String
                    
                    if (result == "success"){
                        let alert = UIAlertController(title: "Successful!", message:"The password reset was successfully", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                        alert.addAction(action)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(alert, animated: true){}
                        })
                        
                        
                    } else if (result == "error"){
                        let alert = UIAlertController(title: "Failed!", message:"The user does not exist", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                        alert.addAction(action)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(alert, animated: true){}
                        })
                        
                        
                    }
                } catch let error as JSONError {
                    print(error.rawValue)
                } catch {
                    print(error)
                }
                }.resume()
        }

        
    
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
