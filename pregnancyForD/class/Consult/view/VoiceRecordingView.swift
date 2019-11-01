//
//  VoiceRecordingView.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/10/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class VoiceRecordingView: UIView {

    let dynamicImageV : UIImageView = UIImageView()
    
    let infoL : UILabel = UILabel()
    
    var changeInfo : changeBlock?
    
    var timer : Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        startAnim()
    }
    
    func stop(){
        self.removeFromSuperview()
        timer?.invalidate()
    }
    
    func startAnim() {
        // 创建定时器
        timer = Timer(timeInterval: 0.5,
                      target: self,
                      selector: #selector(VoiceRecordingView.updateImage),
                      userInfo: nil,
                      repeats: true)
        
        // 将定时器添加到运行循环
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    @objc func updateImage(){
        var i = arc4random() % 4
        i = i + 1
        self.dynamicImageV.image = UIImage.init(named: String.init(format: "%d", i))
    }
    
    func initUI() {
        
        let coverV = UIToolbar()
        self.addSubview(coverV)
        let space = AppDelegate.shareIntance.space
        coverV.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 44 - space.bottomSpace)
        
        let containerV = UIView()
        coverV.addSubview(containerV)
        containerV.snp.updateConstraints({ (make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.centerX.equalTo(coverV)
            make.centerY.equalTo(coverV).offset(-60)
        })
        
        let voicetubeImageView = UIImageView()
        containerV.addSubview(voicetubeImageView)
        voicetubeImageView.image = UIImage.init(named: "HC-mack")
        voicetubeImageView.contentMode = .center
        voicetubeImageView.snp.updateConstraints({ (make) in
            make.top.equalTo(containerV)
            make.left.equalTo(containerV)
            make.bottom.equalTo(containerV)
            make.width.equalTo(80)
        })
        
        containerV.addSubview(dynamicImageV)
        dynamicImageV.image = UIImage.init(named: "1")
        dynamicImageV.contentMode = .bottomLeft
        dynamicImageV.snp.updateConstraints({ (make) in
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.centerY.equalTo(containerV)
            make.right.equalTo(containerV)
            
        })
        
        //提示标语
        coverV.addSubview(infoL)
        infoL.text = "手指上滑，取消发送"
        infoL.snp.updateConstraints({ (make) in
            make.top.equalTo(containerV.snp.bottom).offset(5)
            make.centerX.equalTo(containerV)
        })
    }
    
}

