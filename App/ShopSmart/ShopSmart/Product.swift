//
//  Product.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/5/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import Foundation

struct Product {
    
    var productId:Int?
    var productTitle:String?
    //var productDesc:String?
    //var prodImgUrl:String
  
    
    
    init(data : NSDictionary){
        productId = data["product_id"] as! Int
       // productDesc = data["product_desc"] as! String
        productTitle = data["product_name"] as! String
        //offerExpiry = (data["offer_end_date"] as! NSDate)
       // prodImgUrl =  data["prod_img_url"] as! String
    }
}