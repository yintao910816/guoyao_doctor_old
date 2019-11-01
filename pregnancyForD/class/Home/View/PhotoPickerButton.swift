//
//  PhotoPickerButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/30.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class PhotoPickerButton: UIButton {
    
    let titleL = UILabel()
    let imageV = UIImageView()

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
    }

    override func layoutSubviews() {
        
        self.addSubview(titleL)
        self.addSubview(imageV)
        
        titleL.textColor = kDefaultThemeColor
        
        imageV.snp.updateConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.centerY).offset(5)
        }
        imageV.contentMode = .center
        
        titleL.snp.updateConstraints({ (make) in
            make.width.height.equalTo(40)
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.centerY).offset(-5)
        })
        titleL.textAlignment = NSTextAlignment.center
        titleL.font = UIFont.systemFont(ofSize: 13)
     
    }
    
}
