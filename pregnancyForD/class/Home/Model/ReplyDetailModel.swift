//
//  ReplyDetailModel.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/3/5.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class ReplyDetailModel: NSObject, HandyJSON {
    
    
    var doctorId : NSNumber?
    var replyContent : String?
    var id_ : NSNumber?
    var replyType : String?
    var push_status : NSNumber?
    
    var crew_doctor_id : NSNumber?
    var consultId : NSNumber?
    var doctorName : String?
    var is_read : NSNumber?
    var replyImglist : NSArray?
    
    var patientId : NSNumber?
    var replyTime : String?
    var doctorHeadImg : String?

    required override init() { }

}
