//
//  GroupPatientModels.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/3/6.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class GroupPatientModels: NSObject, HandyJSON {
    
    var doctorId : String?
    var docTagName : String?
    var doctorIds : String?
    var patientList : [PatientModel]?{
        didSet{
            count = (patientList?.count) ?? 0
        }
    }
    
    
    var count : NSInteger = 0
    var isSelected : Bool = false

//    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["patientList" : PatientModel.classForCoder()]
//    }

    required override init() { }
}
