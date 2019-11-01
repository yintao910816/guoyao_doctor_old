//
//  ConsultPickModel.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/10/19.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class ConsultPickModel: NSObject, HandyJSON {
    
    var consultId : NSNumber?

    //来自谁？
    var isPati : String?
    
    var type : String?
    
    var endTime : String?
    
    var headImg : String?
    var createT : String?
    var status : String?
    
    var replyT : String?
    
    var doctName : String?
    
    var content : String?
    
    var imageList : [String]?{
        get{
            if let arr = imageArr{
                if arr.count > 3{
                    var t = [String]()
                    for i in 0..<3{
                        t.append(arr[i])
                    }
                    return t
                }else{
                    return arr
                }
            }else{
                return [""]
            }
        }
    }
    
    var imageArr : [String]?
    
    var voiceStr : String?
        
    convenience init(type : String, model : PatientReplyModel, replyM : ReplyDetailModel?) {
        self.init()
        self.type = type
        if type == TypeMix {
            self.isPati = "1"
            self.consultId = model.consultId
            self.headImg = model.headImg
            self.createT = Date.createTimeWithString((model.createTime)!)
            
            self.endTime = model.endTime
            
            if let s = model.currentStatus{
                switch (s.intValue){
                case 0: self.status = "未回复"
                case 1: self.status = "已回复"
                case 2: self.status = "已完结"
                case 3: self.status = "退回"
                case 4: self.status = "退回"
                default: self.status = "已结束"
                }
            }
            
            self.content = model.content
            if let arr = model.consultImglist{
                if arr.count > 0{
                    self.imageArr = arr as! [String]
                }else{
                    self.type = TypeText
                }
            }else{
                self.type = TypeText
            }
        }else{
            if let m = replyM{
                if type == TypeText {
                    self.isPati = "0"
                    self.consultId = m.consultId
                    if m.crew_doctor_id?.intValue == 0 {
                        self.headImg = m.doctorHeadImg
                    }else{
                        self.headImg = m.doctorHeadImg
                        self.doctName = m.doctorName
                    }
                    self.createT = Date.convertTimeStr(m.replyTime!)
                    self.replyT = m.replyTime
                    self.content = m.replyContent
                }else if type == TypePic{
                    self.isPati = "0"
                    if m.crew_doctor_id?.intValue == 0 {
                        self.headImg = m.doctorHeadImg
                    }else{
                        self.headImg = m.doctorHeadImg
                        self.doctName = m.doctorName
                    }
                    self.createT = Date.convertTimeStr(m.replyTime!)
                    self.replyT = m.replyTime
                    self.imageArr = m.replyImglist as! [String]
                }else if type == TypeVoice{
                    self.isPati = "0"
                    if m.crew_doctor_id?.intValue == 0 {
                        self.headImg = m.doctorHeadImg
                    }else{
                        self.headImg = m.doctorHeadImg
                        self.doctName = m.doctorName
                    }
                    self.createT = Date.convertTimeStr(m.replyTime!)
                    self.voiceStr = String.init(format: "%d", Date.convertTimeStr(m.replyTime!))
                    self.replyT = m.replyTime
                    self.imageArr = m.replyImglist as! [String]
                }
            }
        }
    }
    
    // MARK:- 构造函数
//    init(_ dict : [String : Any]) {
//        super.init()
//        setValuesForKeys(dict)
//    }
//
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    required override init() { }
}
