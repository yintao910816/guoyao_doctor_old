//
//  UserSetTableViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/11.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class UserSetTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        titleLabel.textColor = UIColor.lightGray
        informationL.textColor = kDefaultBlueColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
