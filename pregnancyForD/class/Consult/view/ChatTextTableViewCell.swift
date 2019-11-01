//
//  ChatTextTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ChatTextTableViewCell: BaseChatTableViewCell {
    
    lazy var textL : UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.init(name: kReguleFont, size: 18)
        l.textAlignment = NSTextAlignment.left
        return l
    }()
    
    lazy var nameL : UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textAlignment = NSTextAlignment.center
        l.font = UIFont.init(name: kReguleFont, size: 12)
        return l
    }()
    
    lazy var statusL : UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.textColor = UIColor.white
        l.textAlignment = NSTextAlignment.center
        l.layer.cornerRadius = 5
        l.clipsToBounds = true
        l.font = UIFont.init(name: kReguleFont, size: 14)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(statusL)
        self.addSubview(textL)
        self.addSubview(nameL)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var viewModel: ConsultViewmodel? {
        didSet{
            textL.frame = viewModel?.wordsF ?? CGRect.zero
            textL.text = viewModel?.model?.content
            
            nameL.frame = viewModel?.nameF ?? CGRect.zero
            nameL.text = viewModel?.model?.doctName
            
            statusL.frame = viewModel?.statusF ?? CGRect.zero
            statusL.text = viewModel?.model?.status
            
            if viewModel?.model?.status == "未回复"{
                statusL.backgroundColor = kDefaultThemeColor
            }else{
                statusL.backgroundColor = kDefaultBlueColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
