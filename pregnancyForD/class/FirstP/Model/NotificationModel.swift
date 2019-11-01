//
//  NotificationModel.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/2/7.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class NotificationModel: NSObject, HandyJSON {
    
    var content : String?
    var status : NSNumber?
    var validityDate : String?
    var id : NSNumber?
    var updateTime : NSNumber?
    
    var title : String?
    var hospitalId : NSNumber?
    var type : NSNumber?
    var createTime : String?
    var url : String?
    
    
    // MARK:- 构造函数
//    init(_ dict : [String : Any]) {
//        super.init()
//
//        setValuesForKeys(dict)
//    }
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    required override init() { }
}
