//
//  AuditionButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class AuditionButton: UIButton {

    let secondsLabel = UILabel()
    let shitingImageV = UIImageView()
    let titleL = UILabel()
    
    override func draw(_ rect: CGRect) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = kDefaultThemeColor
        
        titleL.text = "试听"
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = UIColor.white
        self.addSubview(titleL)
        
        secondsLabel.text = "12'"
        secondsLabel.textColor = UIColor.white
        self.addSubview(secondsLabel)
        
        shitingImageV.image = UIImage.init(named: "HC-shiting")
        self.addSubview(shitingImageV)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        secondsLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.centerY.equalTo(self)
        }
        
        shitingImageV.snp.updateConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.height.equalTo(32)
        })
        shitingImageV.contentMode = .center
        
        
        titleL.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.centerY.equalTo(self)
            make.width.equalTo(60)
        }
        titleL.textAlignment = NSTextAlignment.right
        
    }
 

}
