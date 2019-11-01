//
//  ConsultCollectionViewCell.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/10/19.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class ConsultCollectionViewCell: UICollectionViewCell {
    lazy var imgV : UIImageView = {
        let i = UIImageView.init()
        i.layer.cornerRadius = 5
        i.clipsToBounds = true
        return i
    }()
    
    
    var urlS : String? {
        didSet{
            imgV.HC_setImageFromURL(urlS: urlS!, placeHolder: "HC-Dr-2")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgV)
        imgV.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
