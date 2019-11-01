//
//  RejectAndReplyView.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/10/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class RejectAndReplyView: UITableViewHeaderFooterView {
    var rejectBlock : blankBlock?
    var replyBlock : blankBlock?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initUI(){
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        v.backgroundColor = UIColor.white
        
//        let rejectBtn = UIButton()
        let replyBtn = UIButton()
        
//        v.addSubview(rejectBtn)
//        rejectBtn.snp.updateConstraints { (make) in
//            make.left.equalTo(v).offset(KDefaultPadding)
//            make.top.equalTo(v).offset(5)
//            make.height.equalTo(30)
//        }
//        rejectBtn.backgroundColor = kDefaultThemeColor
//        rejectBtn.setTitle("退回", for: .normal)
//        rejectBtn.titleLabel?.textColor = UIColor.white
//        rejectBtn.clipsToBounds = true
//        rejectBtn.layer.cornerRadius = 5
//
//        rejectBtn.addTarget(self, action: #selector(RejectAndReplyView.doctorReject), for: .touchUpInside)
        
        v.addSubview(replyBtn)
        replyBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(v)
            make.left.equalTo(v).offset(KDefaultPadding)
            make.right.equalTo(v).offset(-KDefaultPadding)
            make.height.equalTo(30)
//            make.centerY.equalTo(rejectBtn)
//            make.width.height.equalTo(rejectBtn)
//            make.left.equalTo(rejectBtn.snp.right).offset(KDefaultPadding)
//            make.right.equalTo(v).offset(-KDefaultPadding)
        }
        replyBtn.backgroundColor = kDefaultThemeColor
        replyBtn.setTitle("回复", for: .normal)
        replyBtn.titleLabel?.textColor = UIColor.white
        replyBtn.clipsToBounds = true
        replyBtn.layer.cornerRadius = 5
        
        replyBtn.addTarget(self, action: #selector(RejectAndReplyView.reply), for: .touchUpInside)
        
        let d = UIView.init(frame: CGRect.init(x: 0, y: 41, width: SCREEN_WIDTH, height: 3))
        d.backgroundColor = kdivisionColor
        v.addSubview(d)
        
        self.addSubview(v)
    }
    
    func doctorReject(){
        if let rejectBlock = rejectBlock{
            rejectBlock()
        }
    }
   
    @objc func reply(){
        if let replyBlock = replyBlock{
            replyBlock()
        }
    }
}
