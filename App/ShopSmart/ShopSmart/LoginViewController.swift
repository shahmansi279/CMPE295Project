//
//  LoginViewController.swift
//  ShopSmart
//
//  Created by Jessie Deot on 2/28/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func loginBtn(sender: UIButton) {
        
        
        let usernameText = usernameField.text!
        let passwordText = passwordField.text!
        
        if ( usernameText == "" || passwordText == "" ) {
            
            let alert = UIAlertController(title: "Login Failed!", message:"Please enter a valid Username and Password", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
            
        } else {
            
            
            let urlPath = "\(Constant.baseURL)/smartretailapp/login/?username=\(usernameText)&password=\(passwordText)"
            print(urlPath)
            guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint");return }
            let request = NSMutableURLRequest(URL:endpoint)
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                do {
                    
                    var csrftoken : String = ""
                    
                    if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String]
                    {
                        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                                                NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                        
                        for cookie in cookies {
                            
                           
                            if(cookie.name == "csrftoken"){
                                
                                csrftoken = cookie.value
                            }
                            
                        }
                        
                    }
                    
                    
                   

                    
                    guard let dat = data else { throw JSONError.NoData }
                    guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                    print(json["status"])
                    
                    let result = json["status"] as? String
                    
                    if (result == "success"){
                        
                        print("Login Successful")
                        
                        let id = json["id"] as! Int
                        let username = json["username"] as! String
                        let email = json["email"] as! String
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            print("CS" + csrftoken)
                            
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(id, forKey: "id")
                            prefs.setObject(username, forKey: "username")
                            prefs.setObject(email, forKey: "email")
                            prefs.setInteger(1, forKey: "isLoggedIn")
                            prefs.setObject(csrftoken, forKey: "csrftoken")
                            prefs.synchronize()
                            self.performSegueWithIdentifier("LoggedIn", sender: nil)
                        })
                        
                    } else if (result == "error: disabled account"){
                        print("error: disabled account")
                        let alert = UIAlertController(title: "Login Failed!", message:"The Account has been Disabled", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default) { _ in}
                        alert.addAction(action)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(alert, animated: true){}
                        })
                        
                    } else if (result == "error: invalid credentials"){
                        print("error: invalid credentials")
                        let alert = UIAlertController(title: "Login Failed!", message:"Invalid Credentials", preferredStyle: .Alert)
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
    
    
    
    
    @IBOutlet weak var Menu: UIBarButtonItem!{
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        
        //Looks for single or multiple taps.
      //  let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
      //  view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
