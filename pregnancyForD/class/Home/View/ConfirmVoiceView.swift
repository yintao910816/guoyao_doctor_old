//
//  ConfirmVoiceView.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/19.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class ConfirmVoiceView: UIView {
    
    var playBlock : blankBlock?
    var deleteBlock : blankBlock?
    var sendBlock : blankBlock?
    
    let auditionBtn = AuditionButton.init(frame: CGRect.init(x: 2, y: 2, width: SCREEN_WIDTH * 0.4, height: 40))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    
        self.addSubview(auditionBtn)
        auditionBtn.snp.updateConstraints({ (make) in
            make.top.equalTo(self).offset(2)
            make.bottom.equalTo(self).offset(-2)
            make.left.equalTo(self).offset(2)
            make.width.equalTo(SCREEN_WIDTH * 0.4)
        })
        auditionBtn.addTarget(self, action: #selector(ConfirmVoiceView.startPlaying), for: .touchUpInside)
    
        let deleteBtn = DeleteButton.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH * 0.3, height: 40))
        self.addSubview(deleteBtn)
        deleteBtn.snp.updateConstraints({ (make) in
        make.top.equalTo(self).offset(2)
        make.bottom.equalTo(self).offset(-2)
        make.left.equalTo(auditionBtn.snp.right).offset(2)
        make.width.equalTo(SCREEN_WIDTH * 0.3)
        })
        deleteBtn.addTarget(self, action: #selector(ConfirmVoiceView.deleteVoice), for: .touchUpInside)
    
        let sendBtn = SendButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        self.addSubview(sendBtn)
        sendBtn.snp.updateConstraints({ (make) in
        make.top.equalTo(self).offset(2)
        make.bottom.equalTo(self).offset(-2)
        make.left.equalTo(deleteBtn.snp.right).offset(2)
        make.right.equalTo(self).offset(-2)
        })
        sendBtn.addTarget(self, action: #selector(ConfirmVoiceView.sendVoice), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func startPlaying(){
        if let playBlock = playBlock{
            playBlock()
        }
    }
    
    @objc func deleteVoice(){
        if let deleteBlock = deleteBlock{
            deleteBlock()
        }
    }
    
    @objc func sendVoice(){
        if let sendBlock = sendBlock{
            sendBlock()
        }
    }
}
