//
//  PatientReplyModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/26.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class PatientReplyModel: NSObject, HandyJSON {
    
    var content : String?
    var patientName : String?
    var consultImglist : NSArray?
    var consultId : NSNumber?
    var doctorName : String?
    
    var patientId : NSNumber?
    var currentStatus : NSNumber?
    var createTime : NSNumber?
    var lastestTime : NSNumber?
    var headImg : String?
    
    var replyList : [ReplyDetailModel]?
    var consultImg : String?

    
    var endTime : String = ""
    
//    var doctorId : NSNumber?


//    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["replyList" : ReplyDetailModel.classForCoder()]
//    }
    
    required override init() { }
}
