//
//  GroupButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/15.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class GroupButton: UIButton {
    lazy var infoL : UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 40))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(infoL)
        infoL.snp.updateConstraints { (make) in
            make.center.equalTo(self)
        }
        
        infoL.textColor = kGroupTextColor
        self.layer.borderColor = kGroupTextColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
