//
//  SupplyReplyView.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/10/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class SupplyReplyView: UITableViewHeaderFooterView {
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
        
        let supplementBtn = UIButton()
        
        v.addSubview(supplementBtn)
        supplementBtn.snp.updateConstraints { (make) in
            make.left.equalTo(v).offset(KDefaultPadding)
            make.right.equalTo(v).offset(-KDefaultPadding)
            make.top.equalTo(v).offset(5)
            make.height.equalTo(30)
        }
        supplementBtn.backgroundColor = kDefaultThemeColor
        supplementBtn.setTitle("补充回复", for: .normal)
        supplementBtn.addTarget(self, action: #selector(SupplyReplyView.reply), for: .touchUpInside)
        supplementBtn.clipsToBounds = true
        supplementBtn.layer.cornerRadius = 5
        
        let d = UIView.init(frame: CGRect.init(x: 0, y: 41, width: SCREEN_WIDTH, height: 3))
        d.backgroundColor = kdivisionColor
        v.addSubview(d)
        
        self.addSubview(v)
    }
    
    @objc func reply(){
        if let replyBlock = replyBlock{
            replyBlock()
        }
    }
    
    func nothingButStudy(){
        HCPrint(message: "nothing ok it")
    }
}
