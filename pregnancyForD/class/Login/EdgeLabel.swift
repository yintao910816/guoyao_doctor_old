//
//  EdgeLabel.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class EdgeLabel: UILabel {

    var textInsets :UIEdgeInsets?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textInsets = UIEdgeInsets.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets!))
    }
   
    
//    
//    - (void)drawTextInRect:(CGRect)rect {
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
//    }
//

}
