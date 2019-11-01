//
//  HCNoticeTableViewCell.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/2/7.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class HCNoticeTableViewCell: UITableViewCell {
    
    lazy var imgV : UIImageView = {
        let i = UIImageView()
        i.contentMode = .center
        i.image = UIImage.init(named: "noticeNew")
        return i
    }()
    
    lazy var titleL : UILabel = {
        let t = UILabel()
        t.font = UIFont.init(name: kReguleFont, size: kTextSize)
        t.textColor = kTextColor
        return t
    }()
    
    lazy var detailL : UILabel = {
        let d = UILabel()
        d.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        d.textColor = kLightTextColor
        return d
    }()
    
    lazy var timeL : UILabel = {
        let t = UILabel()
        t.font = UIFont.init(name: kReguleFont, size: kTextSize - 4)
        t.textColor = kLightTextColor
        return t
    }()
    
    
    var model : NotificationModel?{
        didSet{
            if let m = model{
                titleL.text = m.title
                detailL.text = m.content
                timeL.text = m.createTime
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(imgV)
        self.addSubview(titleL)
        self.addSubview(detailL)
        self.addSubview(timeL)
        
        imgV.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        titleL.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.left.equalTo(imgV.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        detailL.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(3)
            make.left.equalTo(titleL)
            make.right.equalTo(self).offset(-20)
        }
        
        timeL.snp.updateConstraints { (make) in
            make.centerY.equalTo(titleL)
            make.right.equalTo(self).offset(-20)
        }
        
        let timeIV = UIImageView.init(image: UIImage.init(named: "time"))
        self.addSubview(timeIV)
        timeIV.snp.updateConstraints { (make) in
            make.centerY.equalTo(timeL)
            make.right.equalTo(timeL.snp.left).offset(-5)
            make.height.width.equalTo(15)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
