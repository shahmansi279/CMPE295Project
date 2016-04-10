//
//  CustomButton.swift
//  ShopSmart
//
//  Created by Mansi Modi on 4/10/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//
import Foundation

import UIKit

class CustomButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = true
        self.frame.size.width = 20
      //  self.layer.borderColor = UIColor.redColor().CGColor
       // self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.backgroundColorDark()
        self.tintColor = UIColor.whiteColor()
    }
}