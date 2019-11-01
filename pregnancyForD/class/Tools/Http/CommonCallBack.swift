//
//  CommonCallBack.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class CommonCallBack: NSObject {
    
   
    var infoCode : NSInteger = 200
    var message : String = ""
    var data : Any = ""

    override init() {
        super.init()
    }
    
    func success()->Bool{
        return infoCode == 200
    }
    
}
