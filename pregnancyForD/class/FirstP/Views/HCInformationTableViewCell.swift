//
//  HCInformationTableViewCell.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/1/10.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class HCInformationTableViewCell: UITableViewCell {
    
    lazy var imgV : UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.layer.cornerRadius = 20
        i.clipsToBounds = true
        i.image = UIImage.init(named: "HC_moren-5")
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
    
    lazy var statusL : UILabel = {
        let t = UILabel()
        t.textAlignment = NSTextAlignment.center
        t.font = UIFont.init(name: kReguleFont, size: kTextSize - 4)
        t.textColor = UIColor.white
        t.layer.cornerRadius = 5
        t.clipsToBounds = true
        return t
    }()
    
    
    var model : ConsultMessageModel?{
        didSet{
            if let m = model{
                titleL.text = m.patientName
                detailL.text = m.content
                if let h = m.headImg{
                    imgV.HC_setImageFromURL(urlS: h, placeHolder: "HC_moren-5")
                }
                if let c = m.currentStatus?.intValue{
                    switch c{
                    case 0 : statusL.text = "未回复"
                        statusL.backgroundColor = kDefaultThemeColor
                    case 1 : statusL.text = "已回复"
                        statusL.backgroundColor = kDefaultBlueColor
                    case 2 : statusL.text = "已回复"
                        statusL.backgroundColor = kDefaultBlueColor
                    default : statusL.text = "已退回"
                        statusL.backgroundColor = kDefaultBlueColor
                    }
                }
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
        self.addSubview(statusL)
        
        imgV.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        titleL.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.height.equalTo(20)
            make.left.equalTo(imgV.snp.right).offset(10)
        }
        
        detailL.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(3)
            make.left.equalTo(titleL)
            make.right.equalTo(self).offset(-20)
        }
        
        statusL.snp.updateConstraints { (make) in
            make.centerY.equalTo(titleL)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
//        let timeIV = UIImageView.init(image: UIImage.init(named: "time"))
//        self.addSubview(timeIV)
//        timeIV.snp.updateConstraints { (make) in
//            make.centerY.equalTo(timeL)
//            make.right.equalTo(timeL.snp.left).offset(-5)
//            make.height.width.equalTo(15)
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
