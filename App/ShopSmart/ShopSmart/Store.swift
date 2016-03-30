//
//  Store.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/30/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import Foundation

struct Store {
    
    var storeId:Int
    var storeDesc:String?
    var storeContact:String?
    var storeEmail:String?
    var storeAddress: String?
    var storeWebsite:String?
    
    
    init(data : NSDictionary){
        storeId = (data["store_id"] as! Int)
        storeDesc = (data["store_name"] as? String)
        storeContact = (data["store_phone"] as? String)
        storeEmail = (data["store_email"] as? String)
        storeAddress =  (data["store_address1"] as? String)
        storeWebsite = (data["store_url"] as? String)
    }
}