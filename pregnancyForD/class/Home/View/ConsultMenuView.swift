//
//  ConsultMenuView.swift
//  pregnancyForD
//
//  Created by yintao on 2020/5/7.
//  Copyright © 2020 pg. All rights reserved.
//

import UIKit

enum ConsultMenuAction: Int {
    case unReply = 0
    case reply = 1
}

class ConsultMenuView: UIView {

    private var unReplyButton: UIButton!
    private var replyButton: UIButton!
    private var lineView: UIView!

    public var changeCallBack: ((ConsultMenuAction)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        unReplyButton = UIButton.init(type: .custom)
        unReplyButton.setTitle("未回复", for: .normal)
        unReplyButton.setTitleColor(kDefaultThemeColor, for: .selected)
        unReplyButton.setTitleColor(.black, for: .normal)
        unReplyButton.isSelected = true
        unReplyButton.titleLabel?.font = .systemFont(ofSize: 15)
        unReplyButton.addTarget(self, action: #selector(buttonActions(button:)), for: .touchUpInside)
        
        replyButton = UIButton.init(type: .custom)
        replyButton.setTitle("已回复", for: .normal)
        replyButton.setTitleColor(kDefaultThemeColor, for: .selected)
        replyButton.setTitleColor(.black, for: .normal)
        replyButton.isSelected = false
        replyButton.titleLabel?.font = .systemFont(ofSize: 15)
        replyButton.addTarget(self, action: #selector(buttonActions(button:)), for: .touchUpInside)
        
        lineView = UIView.init()
        lineView.backgroundColor = kDefaultThemeColor
        
        addSubview(replyButton)
        addSubview(unReplyButton)
        addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonActions(button: UIButton) {
        if button == unReplyButton && !unReplyButton.isSelected {
            changeCallBack?(.unReply)
            
            unReplyButton.isSelected = true
            replyButton.isSelected = false
            
            lineView.frame = .init(x: 0, y: frame.size.height - 2, width: frame.size.width / 2.0, height: 2)
        }else if button == replyButton && !replyButton.isSelected {
            changeCallBack?(.reply)

            unReplyButton.isSelected = false
            replyButton.isSelected = true
           
            lineView.frame = .init(x: frame.size.width / 2.0, y: frame.size.height - 2, width: frame.size.width / 2.0, height: 2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.frame = .init(x: 0, y: frame.size.height - 2, width: frame.size.width / 2.0, height: 2)
        
        unReplyButton.frame = .init(x: 0, y: 0, width: frame.size.width / 2.0, height: frame.size.height - 2)
        replyButton.frame = .init(x: frame.size.width / 2.0, y: 0, width: frame.size.width / 2.0, height: frame.size.height - 2)
    }
}
