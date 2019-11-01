//
//  SearchPatientTableViewCell.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/2/24.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class SearchPatientTableViewCell: UITableViewCell {
    
    lazy var headIV : UIImageView = {
        let h = UIImageView.init()
        h.layer.cornerRadius = 20
        h.clipsToBounds = true
        return h
    }()
    
    lazy var nameL : UILabel = {
        let n = UILabel.init()
        n.font = UIFont.init(name: kReguleFont, size: kTextSize)
        return n
    }()
    
    lazy var sexIV : UIImageView = {
        let s = UIImageView.init()
        s.image = UIImage.init(named: "HC-nv")
        return s
    }()
    
    lazy var infoL : UILabel = {
        let i = UILabel.init()
        i.font = UIFont.init(name: kReguleFont, size: kTextSize - 3)
        i.text = "已咨询"
        i.textAlignment = NSTextAlignment.center
        i.textColor = UIColor.white
        i.layer.cornerRadius = 5
        i.clipsToBounds = true
        i.backgroundColor = kDefaultBlueColor
        return i
    }()
    
    lazy var rightIV : UIImageView = {
        let r = UIImageView.init()
        r.image = UIImage.init(named: "HC-you")
        return r
    }()
    
    var model : SearchPatientModel? {
        didSet{
            if let m = model{
                if let imgS = m.headPhoto {
                    headIV.HC_setImageFromURL(urlS: imgS, placeHolder: "HC_moren-5")
                }
                if let nameS = m.name {
                    nameL.text = nameS
                }
                if let sexI = m.sex{
                    if sexI == 1{
                        sexIV.image = UIImage.init(named: "HC-nan")
                        sexIV.snp.updateConstraints({ (make) in
                            make.height.equalTo(15)
                            make.width.equalTo(15)
                        })
                    }else{
                        sexIV.image = UIImage.init(named: "HC-nv")
                        sexIV.snp.updateConstraints({ (make) in
                            make.height.equalTo(15)
                            make.width.equalTo(10)
                        })
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(headIV)
        self.addSubview(nameL)
        self.addSubview(sexIV)
        
        self.addSubview(rightIV)
        self.addSubview(infoL)
        
        headIV.snp.updateConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        nameL.snp.updateConstraints { (make) in
            make.centerY.equalTo(headIV)
            make.left.equalTo(headIV.snp.right).offset(10)
        }
        
        sexIV.snp.updateConstraints { (make) in
            make.centerY.equalTo(headIV)
            make.left.equalTo(nameL.snp.right).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(10)
        }
        
        rightIV.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.height.equalTo(15)
            make.width.equalTo(10)
        }
        
        infoL.snp.updateConstraints { (make) in
            make.right.equalTo(rightIV.snp.left).offset(-10)
            make.centerY.equalTo(self)
            make.width.equalTo(50)
            make.height.equalTo(20)
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
