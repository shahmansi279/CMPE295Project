//
//  Sensor.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/25/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import Foundation


import Foundation


struct Sensor {
    
    var sensorId:String?
    var sensorName:String?
    var sensorMajor:UInt16?
    var sensorMinor:UInt16?
    var sensorUUID:String?
   
    var sensorTag: String?
    var macName : String?
    
    init(data : NSDictionary){
        
        sensorId = data["id"] as? String
        sensorName = data["sensor_name"] as? String
        sensorMajor = UInt16( ((data["sensor_major"])! as! Int))
        sensorMinor = UInt16( ((data["sensor_minor"])! as! Int))
        sensorUUID=(data["sensor_uuid"] as? String)
        sensorTag = data["sensor_tag"] as? String
        macName = data["sensor_mac_addr"] as? String
        
        
        
        
    }
    
    
    
}