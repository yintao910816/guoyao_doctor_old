//
//  HC-informationModel.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/1/10.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class ConsultMessageModel: NSObject, HandyJSON {
    
    var content : String?
    var doctorId : NSNumber?
    var patientName : String?
    var identityNo : String?
    var create_time : String?
    
    var doctorName : String?
    var headImg : String?
    var patientId : NSNumber?
    var currentStatus : NSNumber?
    var doctorIds : String?
    
    var lastestTime : String?
    
    
    // MARK:- 构造函数
//    init(_ dict : [String : Any]) {
//        super.init()
//
//        setValuesForKeys(dict)
//    }
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    required override init() { }

}
