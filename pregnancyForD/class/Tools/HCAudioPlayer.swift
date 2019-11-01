//
//  HCAudioPlayer.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/22.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class HCAudioPlayer: AVAudioPlayer {
    weak var replyVoiceV : ChatVoiceTableViewCell?
    
    override func stop() {
        super.stop()
        if let replyVoiceV = replyVoiceV {
            replyVoiceV.timer?.invalidate()
            replyVoiceV.voiceBtn.voiceIV.image = UIImage.init(named: "hc_yuyin33")
        }
    }

}
