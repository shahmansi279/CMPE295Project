//
//  ListTableViewCell.swift
//  ShopSmart
//
//  Created by Jessie Deot on 3/17/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
