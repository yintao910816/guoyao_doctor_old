//
//  SharePlayer.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class SharePlayer: NSObject {

    public var audioPlayer: HCAudioPlayer!
        
    // 设计成单例
    static let shareIntance : SharePlayer = {
        let tools = SharePlayer()

        do {
            let pathS = Bundle.main.path(forResource: "defaultVoice", ofType: "wav")
            let url = URL.init(fileURLWithPath: pathS!)
            let data = try! Data.init(contentsOf: url)
            //            try p = HCAudioPlayer.init(contentsOf: url)
            try tools.audioPlayer = HCAudioPlayer.init(data: data)
            
            tools.audioPlayer.prepareToPlay()
        } catch {
            
        }

        return tools
    }()
    
    

}
