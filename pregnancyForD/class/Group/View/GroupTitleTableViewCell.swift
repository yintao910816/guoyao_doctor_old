//
//  GroupTitleTableViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/11.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class GroupTitleTableViewCell: UITableViewCell {
    
    var tagGroupModel : GroupPatientModels? {
        didSet{
            groupNameL.text = (tagGroupModel?.docTagName)! + String.init(format: " ( %d )", (tagGroupModel?.count)!)
            foldBtn.isSelected = (tagGroupModel?.isSelected)!
        }
    }
    

    @IBOutlet weak var foldBtn: UIButton!
    
    @IBOutlet weak var groupNameL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
