//
//  Cart.swift
//  ShopSmart
//
//  Created by Jessie Deot on 3/14/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import Foundation

struct Cart {
    
    var cartProductId:Int?
    var cartId:Int?
    var productId:Int?
    var productQty:Int?
    var productTitle:String?
    
    
    init(data : NSDictionary){
        cartProductId = data["cart_product_id"] as? Int
        cartId = data["cart_id"] as? Int
        productTitle = data["cart_prd_attr1"] as? String
        productId = data["product_id"] as? Int
        productQty = data["product_qty"] as? Int
        
    }
}