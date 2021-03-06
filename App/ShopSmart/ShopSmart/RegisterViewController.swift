//
//  RegisterViewController.swift
//  ShopSmart
//
//  Created by Jessie Deot on 2/14/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
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
    
    @IBAction func RegisterBtn(sender: UIButton) {
        
        
        let usernameText = usernameField.text!
        let passwordText = passwordField.text!
        let verifyPasswordText = verifyPasswordField.text!
        let emailText = emailField.text!
        let addressText = addressField.text!
        let zipcodeText = zipcodeField.text!
        let phoneText = phoneField.text!
        let dobText = dobField.text!
        let genderText = genderField.text!
        let cardNoText = cardNoField.text!
        
        if ( usernameText == "" || passwordText == "" || verifyPasswordText == "" ) {
            
            let alert = UIAlertController(title: "Registration Failed!", message:"Please enter the required fields", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
            
        } else if (passwordText != verifyPasswordText) {
            let alert = UIAlertController(title: "Registration Failed!", message:"The passwords do not match. Try again!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in}
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
            
        } else {
            
            
            let urlPath = "\(Constant.baseURL)/smartretailapp/register/?username=\(usernameText)&password=\(passwordText)&email=\(emailText)&user_addr=\(addressText)&user_zip=\(zipcodeText)&user_phone=\(phoneText)&user_dob=\(dobText)&user_gender=\(genderText)&user_card=\(cardNoText)"
            
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
                        print("Registration successful")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.registered()
                        })
                        
                    } else if (result == "error"){
                        let alert = UIAlertController(title: "Registration Failed!", message:"The username is already taken. Try again!", preferredStyle: .Alert)
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
    
    func registered(){
        let alert = UIAlertController(title: "Registration successful!", message:"The Account has been Registered", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("Registered", sender: nil)
        }))
        self.presentViewController(alert, animated: true){}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        self.genderField.delegate = self;
        self.verifyPasswordField.delegate = self;
        self.emailField.delegate = self;
        self.addressField.delegate = self;
        self.zipcodeField.delegate = self;
        self.phoneField.delegate = self;
        self.cardNoField.delegate = self;
        self.dobField.delegate = self;
        //Looks for single or multiple taps.
       // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
       // view.addGestureRecognizer(tap)

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
