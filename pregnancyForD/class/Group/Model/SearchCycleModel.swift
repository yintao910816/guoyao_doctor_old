//
//  SearchCycleModel.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/2/24.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class SearchCycleModel: NSObject, HandyJSON {
    
    var doctorId : String?
    var patientId : String?
    var schemeName : String?
    var identityNo : String?
    var age_m : String?
    
    var identif_m : String?
    var identif_w : String?
    var age_w : String?
    var oId : String?
    var name_w : String?
    
    var pId : String?
    var name_m : String?

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
