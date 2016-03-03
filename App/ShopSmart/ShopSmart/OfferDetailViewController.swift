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
    @IBOutlet weak var desc: UILabel!
    
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
        self.desc.text=offer.offerDesc
        
        dispatch_async(dispatch_get_main_queue()){
            
            let bgImage = UIImage(data:imageData)
            
            self.imgView.image = bgImage
            
            
        }

    
    
    
    }
}
