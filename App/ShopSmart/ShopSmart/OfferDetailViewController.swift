//
//  OfferDetailController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/2/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit

class OfferDetailViewController: UIViewController {
    
    var offer: Offer!
    @IBOutlet weak var imgView: UIImageView!
   
    @IBOutlet var offer_desc: UITextView!
    
    @IBOutlet var offer_exp_date: UILabel!
    @IBOutlet weak var offer_title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the pan gesture to the view.
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        
        
        // Do any additional setup after loading the view.
        
        load()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func load(){
        
        
       
        let url = NSURL(string: "\(offer.offerImgUrl)")
         let imageData: NSData = NSData(contentsOfURL: url!)!
        
        self.offer_title.text=offer.offerTitle
        self.offer_desc.text=offer.offerDesc
        self.offer_exp_date.text=String(offer.offerExpiry!)
        
        dispatch_async(dispatch_get_main_queue()){
            
            let bgImage = UIImage(data:imageData)
            
            self.imgView.image = bgImage
            
            
        }

    
    
    
    }
}
