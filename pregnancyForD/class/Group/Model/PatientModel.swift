//
//  PatientModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/26.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class PatientModel: NSObject, HandyJSON {
    
//    var patientAge : NSNull?
//    var tagName : NSNull?
//    var refused : String?
//    var patientToken : String?
//    var doctorid : NSNull?
//    var patientRealName : NSNull?
//    var headImg : NSNull?
//    var charged : String?
//    var p_id : NSNumber?
//    var patientGender : NSNumber?
//    var comm : NSNull?
//    var patientNickName : String?
//    var tagId : NSNull?


    var headImg : String?
    var patientName : String?
    var patientAge : NSNumber?
    var identityNo : String?
    var tagName : String?
    
    var doctorName : String?
    var patientId : NSNumber?
    var currentStatus : NSNumber?
    var patientSex : NSNumber?
    
    var lastestTime : NSNumber?
    
    //记录字段
    var doctorIds : String?
    
    
    
    //需要字段
    var charged : String?
    var refused : String?
    
    
    
    //之前的字段
    var patientToken : String?
    var doctorid : NSNull?
    var patientRealName : String?{
        didSet{
            if let p = patientRealName{
                patientName = p
            }
        }
    }
    var p_id : NSNumber?{
        didSet{
            if let i = p_id{
                patientId = i
            }
        }
    }
    var patientGender : NSNumber?
    var comm : NSNull?
    var patientNickName : String?{
        didSet{
            if let p = patientNickName{
                patientName = p
            }
        }
    }
    
    
    
//    convenience init(_ dic : [String : Any]) {
//        self.init()
//        setValuesForKeys(dic)
//    }
//
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        //
//    }

    required override init() { }

}
