//
//  HomeTableViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    
    let headImage = UIImageView()
    let badgeNumber = UILabel()
    let patientName = UILabel()
//    let patientGroup = UILabel()     // 有问题！
    let creatTime = UILabel()
    
    let consultContent = UILabel()
    let fromGroup = UILabel()
    
    var consultModel : ConsultModel? {
        didSet{
            //角标
            if consultModel?.unReplyCount?.intValue != 0 && consultModel?.unReplyCount != nil{
                badgeNumber.text = consultModel?.unReplyCount?.stringValue
                badgeNumber.isHidden = false
            }else{
                badgeNumber.isHidden = true
            }
            
            if let name = consultModel?.patientName {
                patientName.text = name
            }else{
                patientName.text = "匿名"
            }
            
            if let imgS = consultModel?.headImg{
                headImage.HC_setImageFromURL(urlS: imgS, placeHolder: "HC_moren-5")
            }else{
                headImage.image = UIImage.init(named: "HC_moren-5")
            }
            
            creatTime.text = Date.createTimeWithString((consultModel?.lastestTime)!)
            creatTime.sizeToFit()
            
            consultContent.text = consultModel?.content
            
//            if consultModel?.tagName == nil || consultModel?.tagName == ""{
//                patientGroup.text = "默认分组"
//            }else{
//                patientGroup.text = consultModel?.tagName
//            }
//            patientGroup.sizeToFit()
//            let tempF = patientGroup.frame
//            let width = tempF.size.width + 6
//            let height = tempF.size.height + 6
//            patientGroup.snp.updateConstraints { (make) in
//                make.width.equalTo(width)
//                make.height.equalTo(height)
//            }
        
            if let f = consultModel?.doctorName {
                fromGroup.text = String.init(format: "来自%@", f)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.addSubview(headImage)
        headImage.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(KDefaultPadding)
            make.width.height.equalTo(40)
            make.centerY.equalTo(self)
        }
        headImage.layer.cornerRadius = 20
        headImage.clipsToBounds = true
        headImage.contentMode = .scaleAspectFill
        
        self.addSubview(badgeNumber)
        badgeNumber.snp.updateConstraints { (make) in
            make.centerY.equalTo(headImage.snp.top).offset(5)
            make.right.equalTo(headImage.snp.right)
            make.width.height.equalTo(15)
        }
        badgeNumber.backgroundColor = UIColor.red
        badgeNumber.textColor = UIColor.white
        badgeNumber.layer.cornerRadius = 9
        badgeNumber.clipsToBounds = true
        badgeNumber.textAlignment = NSTextAlignment.center
        badgeNumber.font = UIFont.systemFont(ofSize: 10)
        
        self.addSubview(patientName)
        patientName.snp.updateConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(10)
            make.top.equalTo(self).offset(5)
            make.height.equalTo(18)
        }
        patientName.font = UIFont.systemFont(ofSize: 14)
        
        self.addSubview(creatTime)
        creatTime.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-KDefaultPadding)
            make.centerY.equalTo(patientName)
        }
        creatTime.textColor = kDefaultBlueColor
        creatTime.font = UIFont.systemFont(ofSize: 12)
        
//        self.addSubview(patientGroup)
//        patientGroup.snp.updateConstraints { (make) in
//            make.left.equalTo(patientName)
//            make.top.equalTo(patientName.snp.bottom).offset(3)
//            make.width.equalTo(30)
//            make.height.equalTo(18)
//        }
//        patientGroup.textColor = kDefaultBlueColor
//        patientGroup.textAlignment = NSTextAlignment.center
//        patientGroup.layer.borderColor = kDefaultBlueColor.cgColor
//        patientGroup.layer.borderWidth = 1
//        patientGroup.layer.cornerRadius = 5
//        patientGroup.font = UIFont.systemFont(ofSize: 10)
        
        self.addSubview(fromGroup)
        fromGroup.snp.updateConstraints { (make) in
            make.left.equalTo(patientName)
            make.top.equalTo(patientName.snp.bottom).offset(3)
        }
        fromGroup.font = UIFont.init(name: kReguleFont, size: 12)
        fromGroup.textColor = kLightTextColor
        
        self.addSubview(consultContent)
        consultContent.snp.updateConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(10)
            make.bottom.equalTo(self).offset(-5)
            make.right.equalTo(self).offset(-KDefaultPadding)
            make.height.equalTo(15)
        }
        consultContent.font = UIFont.systemFont(ofSize: 12)
        consultContent.textColor = UIColor.lightGray
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
