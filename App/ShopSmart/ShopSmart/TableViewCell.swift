//
//  TableViewCell.swift
//  ShopSmart
//
//  Created by thinatar on 3/3/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var myLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
