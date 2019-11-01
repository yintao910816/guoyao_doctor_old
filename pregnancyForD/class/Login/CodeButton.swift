//
//  CodeButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/25.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class CodeButton: UIButton {

    let coverLabel = UILabel.init()
  
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        self.addSubview(coverLabel)
        coverLabel.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        coverLabel.textAlignment = NSTextAlignment.center
        coverLabel.font = UIFont.systemFont(ofSize: 15)
        coverLabel.text = "获取验证码"
        coverLabel.textColor = kDefaultThemeColor
        coverLabel.isHidden = true
    }
    
 

}
