//
//  SearchCycleTableViewCell.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/2/24.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class SearchCycleTableViewCell: UITableViewCell {

    lazy var headIV : UIImageView = {
        let h = UIImageView.init()
        h.image = UIImage.init(named: "HC_moren-5")
        h.layer.cornerRadius = 20
        h.clipsToBounds = true
        return h
    }()
    
    lazy var nameW : UILabel = {
        let n = UILabel.init()
        n.font = UIFont.init(name: kReguleFont, size: kTextSize)
        return n
    }()
    
    lazy var ageW : UILabel = {
        let a = UILabel.init()
        a.font = UIFont.init(name: kReguleFont, size: kTextSize - 1)
        return a
    }()
    
    lazy var sexW : UIImageView = {
        let s = UIImageView.init()
        s.image = UIImage.init(named: "HC-nv")
        return s
    }()
    
    lazy var nameM : UILabel = {
        let n = UILabel.init()
        n.font = UIFont.init(name: kReguleFont, size: kTextSize)
        return n
    }()
    
    lazy var ageM : UILabel = {
        let a = UILabel.init()
        a.font = UIFont.init(name: kReguleFont, size: kTextSize - 1)
        return a
    }()
    
    lazy var sexM : UIImageView = {
        let s = UIImageView.init()
        s.image = UIImage.init(named: "HC-nan")
        return s
    }()
    
    lazy var schemeT : UILabel = {
        let s = UILabel.init()
        s.text = "执行方案:"
        s.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        s.textColor = kLightTextColor
        return s
    }()
    
    lazy var schemeL : UILabel = {
        let s = UILabel.init()
        s.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        return s
    }()
    
    lazy var infoL : UILabel = {
        let i = UILabel.init()
        i.font = UIFont.init(name: kReguleFont, size: kTextSize - 3)
        i.text = "生殖病历"
        i.textAlignment = NSTextAlignment.center
        i.textColor = UIColor.white
        i.layer.cornerRadius = 5
        i.clipsToBounds = true
        i.backgroundColor = kDefaultThemeColor
        return i
    }()
    
    lazy var rightIV : UIImageView = {
        let r = UIImageView.init()
        r.image = UIImage.init(named: "HC-you")
        return r
    }()
    
    var model : SearchCycleModel? {
        didSet{
            if let m = model{
                if let s = m.name_w {
                    nameW.text = s
                }
                if let s = m.age_w{
                    ageW.text = String.init(format: "%@岁", s)
                }
                if let s = m.name_m{
                    nameM.text = s
                }
                if let s = m.age_m{
                    ageM.text = String.init(format: "%@岁", s)
                }
                schemeL.text = m.schemeName
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(headIV)
        
        self.addSubview(nameW)
        self.addSubview(ageW)
        self.addSubview(sexW)
        
        self.addSubview(nameM)
        self.addSubview(ageM)
        self.addSubview(sexM)
        
        self.addSubview(infoL)
        
        self.addSubview(schemeT)
        self.addSubview(schemeL)
        
        self.addSubview(rightIV)
        
        headIV.snp.updateConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        nameW.snp.updateConstraints { (make) in
            make.bottom.equalTo(headIV.snp.centerY)
            make.left.equalTo(headIV.snp.right).offset(10)
        }
        
        ageW.snp.updateConstraints { (make) in
            make.centerY.equalTo(nameW)
            make.left.equalTo(nameW.snp.right).offset(6)
        }
        
        sexW.snp.updateConstraints { (make) in
            make.centerY.equalTo(nameW)
            make.left.equalTo(ageW.snp.right).offset(6)
            make.height.equalTo(15)
            make.width.equalTo(10)
        }
        
        nameM.snp.updateConstraints { (make) in
            make.centerY.equalTo(nameW)
            make.left.equalTo(sexW.snp.right).offset(20)
        }
        
        ageM.snp.updateConstraints { (make) in
            make.centerY.equalTo(nameW)
            make.left.equalTo(nameM.snp.right).offset(6)
        }
        
        sexM.snp.updateConstraints { (make) in
            make.centerY.equalTo(nameW)
            make.left.equalTo(ageM.snp.right).offset(6)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        
        infoL.snp.updateConstraints { (make) in
            make.centerY.equalTo(sexM)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(65)
            make.height.equalTo(20)
        }
        
        schemeT.snp.updateConstraints { (make) in
            make.top.equalTo(headIV.snp.centerY).offset(5)
            make.left.equalTo(headIV.snp.right).offset(10)
        }
        
        schemeL.snp.updateConstraints { (make) in
            make.centerY.equalTo(schemeT)
            make.left.equalTo(schemeT.snp.right).offset(10)
        }
        
        rightIV.snp.updateConstraints { (make) in
            make.centerY.equalTo(schemeL)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(15)
            make.width.equalTo(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

