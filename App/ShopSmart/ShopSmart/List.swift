//
//  List.swift
//  ShopSmart
//
//  Created by Jessie Deot on 3/17/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import Foundation

struct List {
    
    var listProductId:Int?
    var listId:Int?
    var productId:Int?
    var productQty:Int?
    var productTitle:String?

    
    
    init(data : NSDictionary){
        listProductId = data["list_product_id"] as? Int
        listId = data["list_id"] as? Int
        productTitle = data["list_prd_attr1"] as? String
        productId = data["product_id"] as? Int
        productQty = data["product_qty"] as? Int
        
    }
}