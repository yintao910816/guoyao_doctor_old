//
//  ResourceShare.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/30.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class ResourceShare: NSObject {
    
    
    lazy var systemPhoto = FindPhotoFromSystem()
    
    // 设计成单例
    static let shareIntance : ResourceShare = {
        let tools = ResourceShare()
        return tools
    }()

}
