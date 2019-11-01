//
//  AudioButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/22.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class AudioButton: UIButton {

    let secondsLabel = UILabel()
    let voiceIV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kDefaultThemeColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        secondsLabel.text = "12'"
        secondsLabel.textColor = UIColor.white
        self.addSubview(secondsLabel)
        secondsLabel.isHidden = true
        
        voiceIV.image = UIImage.init(named: "hc_yuyin33")
        self.addSubview(voiceIV)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        secondsLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        voiceIV.snp.updateConstraints({ (make) in
            make.right.equalTo(self).offset(-8)
            make.centerY.equalTo(self)
            make.width.height.equalTo(30)
        })
        voiceIV.contentMode = .right
        
    }
}
