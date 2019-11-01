//
//  PatientDetailButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/19.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class PatientDetailView: UIView {
    let nameL = UILabel()
    let sexImageV = UIImageView()
    let ageL = UILabel()
    let groupL = UILabel()
    
    var model : PatientModel?{
        didSet{
            if let nameS = model?.patientName {
                nameL.text = nameS
            }else{
                nameL.text = "匿名"
            }
            
            if model?.patientSex?.intValue == 1 {
                sexImageV.image = UIImage.init(named: "HC-nan")
            }else{
                sexImageV.image = UIImage.init(named: "HC-nv")
            }

            if let age = model?.patientAge{
                ageL.text = String.init(format: "%d", age.intValue) + "岁"
            }else{
                ageL.text = "年龄未填写"
            }
            
            if let tagN = model?.tagName{
                groupL.text = tagN
            }else{
                groupL.text = "默认分组"
            }
            groupL.sizeToFit()
            let tempF = groupL.frame
            let width = tempF.size.width + 10
            let height = tempF.size.height + 10
            groupL.snp.updateConstraints({ (make) in
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let containerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        self.addSubview(containerV)
        
        containerV.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.centerY.equalTo(containerV)
            make.left.equalTo(containerV).offset(KDefaultPadding)
        }
        nameL.sizeToFit()
        nameL.font = UIFont.systemFont(ofSize: 17)
        
        
        containerV.addSubview(sexImageV)
        sexImageV.snp.updateConstraints { (make) in
            make.centerY.equalTo(containerV)
            make.width.height.equalTo(30)
            make.left.equalTo(nameL.snp.right).offset(5)
        }
        sexImageV.contentMode = .center
        
        
        containerV.addSubview(ageL)
        ageL.snp.updateConstraints { (make) in
            make.centerY.equalTo(containerV)
            make.left.equalTo(sexImageV.snp.right).offset(5)
        }
        ageL.sizeToFit()
        ageL.font = UIFont.systemFont(ofSize: 15)
        ageL.textColor = UIColor.lightGray
        
        
        containerV.addSubview(groupL)
        groupL.snp.updateConstraints { (make) in
            make.centerY.equalTo(ageL)
            make.left.equalTo(ageL.snp.right).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        groupL.textAlignment = NSTextAlignment.center
        groupL.textColor = kDefaultBlueColor
        groupL.font = UIFont.systemFont(ofSize: 12)
        groupL.layer.borderWidth = 1
        groupL.layer.borderColor = kDefaultBlueColor.cgColor
        groupL.layer.cornerRadius = 5
        
        let youImageV = UIImageView()
        containerV.addSubview(youImageV)
        youImageV.snp.updateConstraints { (make) in
            make.centerY.equalTo(containerV)
            make.right.equalTo(containerV).offset(-KDefaultPadding)
            make.width.height.equalTo(35)
        }
        youImageV.contentMode = .right
        youImageV.image = UIImage.init(named: "HC-you")
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.bottom.equalTo(containerV)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
