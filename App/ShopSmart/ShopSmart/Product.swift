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
    var productDesc:String?
    var prodImgUrl:String
    var productCost:String
  
    
    
    init(data : NSDictionary){
        productId = data["product_id"] as? Int
        productDesc = data["product_desc"] as! String
        productTitle = data["product_name"] as! String
        productCost = data["srp"] as! String
        prodImgUrl =  data["product_img1_url"] as! String
    }
}