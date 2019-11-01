//
//  SendButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class SendButton: UIButton {

    let sendImagev = UIImageView()
    let titleL = UILabel()
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = kDefaultThemeColor
        titleL.text = "发送"
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = UIColor.white
        self.addSubview(titleL)
        
        sendImagev.image =  UIImage.init(named: "HC_fasong")
        self.addSubview(sendImagev)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        sendImagev.snp.updateConstraints({ (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(32)
        })
        sendImagev.contentMode = .center
        
        
        titleL.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.centerY.equalTo(self)
            make.width.equalTo(50)
        }
        
    }
    
    
}
