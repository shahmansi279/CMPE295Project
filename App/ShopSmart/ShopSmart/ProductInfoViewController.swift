//
//  ProductInfoViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/7/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import Foundation

class ProductInfoViewController : UIViewController {
    
    var product: Product!
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet weak var addToCartOutlet: UIButton!
    
    @IBOutlet var prodDesc: UILabel!
    @IBOutlet var prodCost: UILabel!
    @IBOutlet var prodTitle: UILabel!
    
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
        self.prodDesc.text=product.productDesc
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
            print("Quantity: \(textField.text)")
        }))
        
        let cancel = UIAlertAction(title: "CANCEL", style: .Default) { _ in}
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true){}
        
        
        
        
        
        
    }
    
    
    
}








