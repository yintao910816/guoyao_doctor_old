//
//  UserModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class UserModel: NSObject, HandyJSON {
    
    
    var goodProjectList : NSArray?
    var goodProject : String?
    var hospitalName : String?
    var realName : String?
    var token : String?
    var docRole : String?
    var docTitle : String?
    var price : NSNumber?
    var teamMember : NSNumber?
    var headImg : String?
    var duty : String?
    var brief : String?
    var id : NSNumber?
    var nickName : String?
    var feeCount : String?
    var phone : String?
    var docItem : String?
    var sex : NSNumber?
    var feeCountMemo : String?
    
    
    var version : String?
    var website7 : String?
    
    var isMemb : Bool = false
    
    var openId : String?
    
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
