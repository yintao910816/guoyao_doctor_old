//
//  DeleteButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class DeleteButton: UIButton {

    let deleteImagev = UIImageView()
    let titleL = UILabel()
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = kDefaultBlueColor
        titleL.text = "重录"
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = UIColor.white
        self.addSubview(titleL)
        
        deleteImagev.image =  UIImage.init(named: "HC-chonglu")
        self.addSubview(deleteImagev)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        deleteImagev.snp.updateConstraints({ (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(32)
        })
        deleteImagev.contentMode = .center
        
        
        titleL.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.centerY.equalTo(self)
            make.width.equalTo(50)
        }
    }
}
