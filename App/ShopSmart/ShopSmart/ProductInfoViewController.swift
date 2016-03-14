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
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet weak var addToCartOutlet: UIButton!
    
   
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
            
        }        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func load(){
        
        
        
       let url = NSURL(string: "\(product.prodImgUrl)")
       let imageData: NSData = NSData(contentsOfURL: url!)!
        
        let cost = String(product.productCost)
        
        self.prodTitle.text=product.productTitle
        self.productDesc.text=product.productDesc
        self.prodCost.text=cost
        
        dispatch_async(dispatch_get_main_queue()){
            
            let bgImage = UIImage(data:imageData)
            
            self.imgView.image = bgImage
            
            
        }
        
    }
    
    
    
    @IBAction func AddToCartBtn(sender: UIButton) {
        
        let alert = UIAlertController(title: "Add to Cart", message:"Enter Quantity", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Enter Quantity"
        })
        alert.addAction(UIAlertAction(title: "ADD", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            var quantity = Int(textField.text!)
            print(quantity)
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let cart_id:Int = prefs.integerForKey("cart_id") as Int
            
            //let param = ["cart_id" : cart_id , "cart_desc" : "active" , "product_id" : self.product.productId , "product_qty" : quantity] as! NSDictionary
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
            
            
            
        }))

        let cancel = UIAlertAction(title: "CANCEL", style: .Default) { _ in}
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true){}
        
        
        
        
        
        
    }
    
    
    
}








