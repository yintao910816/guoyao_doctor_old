//
//  GroupManagerViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/15.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class GroupManagerViewCell: UICollectionViewCell {
    
    var finalWidth : CGFloat?
    
    var chooseBlock : changeBlock?
    var longPressBlock : changeBlock?
    
    var contentS : String? {
        didSet{
            infoBtn.infoL.text = contentS
            infoBtn.infoL.sizeToFit()
            let tempF = infoBtn.infoL.frame
            finalWidth = tempF.size.width + 20
        }
    }
    
    let infoBtn = GroupButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(infoBtn)
        infoBtn.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        infoBtn.backgroundColor = UIColor.white
        infoBtn.addTarget(self, action: #selector(GroupManagerViewCell.chooseAction), for: .touchUpInside)
        
        let longPressG = UILongPressGestureRecognizer.init(target: self, action: #selector(GroupManagerViewCell.longPressAction))
        longPressG.minimumPressDuration = 1
        infoBtn.addGestureRecognizer(longPressG)
        
    }
    
    @objc func chooseAction(){
        if let chooseBlock = chooseBlock{
            chooseBlock(contentS!)
        }
    }
    
    @objc func longPressAction(){
        if let longPressBlock = longPressBlock{
            longPressBlock(contentS!)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
}
