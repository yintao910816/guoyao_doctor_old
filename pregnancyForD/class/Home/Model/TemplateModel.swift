//
//  TemplateModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/2.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class TemplateModel: NSObject, HandyJSON {
    
    var templateValue : NSNumber?
    var docId : NSNumber?
    var templateContent : String?
    var id : NSNumber?
    
    
    // MARK:- 构造函数
//    init(_ dict : [String : Any]) {
//        super.init()
//
//        setValuesForKeys(dict)
//    }
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    required override init() { }

}
