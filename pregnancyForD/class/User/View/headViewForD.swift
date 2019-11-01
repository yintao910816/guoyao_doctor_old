//
//  headViewForD.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class headViewForD: UIView {
    
    var introBlock : blankBlock?
    var goodatBlock : blankBlock?
    
    let headImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60))
    let nameL = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 110, height: 110))
    let sexImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
    let jobL = UILabel()
    let hospitalLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 30))
    
    let someL = UILabel()
    let introDetail = UILabel()
    
    let contForIntr = UIView()
    let introL = UILabel()
    
    let goodAtL = UILabel()

    var userModel : UserModel? {
        
        didSet{
            if var headImg = userModel?.headImg{
                if !headImg.hasPrefix("http"){
                    headImg = IMAGE_URL + headImg
                }
                let url = URL.init(string: headImg)
                if let url = url {
                    headImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "HC_moren-5"))
                }else{
                    headImageView.image = UIImage.init(named: "HC_moren-5")
                }
            }else{
                headImageView.image = UIImage.init(named: "HC_moren-5")
            }
            
            nameL.text = userModel?.realName
            
            if userModel?.sex?.intValue == 0 {
                sexImageView.image = UIImage.init(named: "HC-nan")
            }else{
                sexImageView.image = UIImage.init(named: "HC-nv")
            }
            
            jobL.text = userModel?.docRole
            jobL.sizeToFit()
            var tempF = jobL.frame
            let width = tempF.size.width + 10
            let height = tempF.size.height + 10
            jobL.snp.updateConstraints({ (make) in
                make.centerY.equalTo(nameL)
                make.left.equalTo(sexImageView.snp.right).offset(20)
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
            
            hospitalLabel.text = userModel?.hospitalName
            
            if let arr = userModel?.goodProjectList{
                let str = arr.componentsJoined(by: "，")
                someL.text = str
            }
            
            introDetail.text = userModel?.brief
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        let containerV = UIView.init()
        self.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        
        containerV.addSubview(headImageView)
        headImageView.snp.updateConstraints({ (make) in
            make.top.equalTo(containerV).offset(20)
            make.centerX .equalTo(containerV)
            make.width.height.equalTo(100)
        })
        headImageView.layer.cornerRadius = 50
        headImageView.clipsToBounds = true
        headImageView.contentMode = .scaleAspectFill
        
        
        containerV.addSubview(nameL)
        nameL.snp.updateConstraints({ (make) in
            make.top.equalTo(headImageView.snp.bottom).offset(16)
            make.right.equalTo(containerV.snp.centerX).offset(-20)
        })
        nameL.font = UIFont.systemFont(ofSize: 17)
        
        
        containerV.addSubview(sexImageView)
        sexImageView.snp.updateConstraints({ (make) in
            make.centerY.equalTo(nameL)
            make.centerX.equalTo(containerV)
        })
        
        containerV.addSubview(jobL)
        jobL.snp.updateConstraints({ (make) in
            make.centerY.equalTo(nameL)
            make.left.equalTo(sexImageView.snp.right).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(22)
        })
        jobL.font = UIFont.systemFont(ofSize: 12)
        jobL.textColor = kDefaultBlueColor
        jobL.textAlignment = NSTextAlignment.center
        jobL.layer.borderWidth = 1
        jobL.layer.borderColor = kDefaultBlueColor.cgColor
        jobL.layer.cornerRadius = 5
        
        
        containerV.addSubview(hospitalLabel)
        hospitalLabel.snp.updateConstraints({ (make) in
            make.top.equalTo(nameL.snp.bottom).offset(16)
            make.centerX.equalTo(containerV)
        })
        hospitalLabel.font = UIFont.systemFont(ofSize: 15)
        hospitalLabel.textColor = UIColor.lightGray
        hospitalLabel.textAlignment = NSTextAlignment.center
        
        
        
        /////// 擅长
        let contForGoodAt = UIView()
        containerV.addSubview(contForGoodAt)
        contForGoodAt.snp.updateConstraints { (make) in
            make.top.equalTo(hospitalLabel.snp.bottom).offset(16)
            make.left.right.equalTo(containerV)
        }
        let goodatTapG = UITapGestureRecognizer.init(target: self, action: #selector(headViewForD.editGoodat))
        contForGoodAt.addGestureRecognizer(goodatTapG)
        
        contForGoodAt.addSubview(goodAtL)
        goodAtL.snp.updateConstraints { (make) in
            make.left.equalTo(contForGoodAt).offset(KDefaultPadding)
            make.top.equalTo(contForGoodAt)
            make.width.equalTo(40)
        }
        goodAtL.text = "擅长"
        goodAtL.textColor = UIColor.lightGray
        goodAtL.font = UIFont.systemFont(ofSize: 17)
        
        contForGoodAt.addSubview(someL)
        someL.snp.updateConstraints({ (make) in
            make.top.equalTo(contForGoodAt).offset(5)
            make.left.equalTo(goodAtL.snp.right).offset(KDefaultPadding)
            make.width.equalTo(Int(SCREEN_WIDTH) - KDefaultPadding * 4 - 55)
            make.bottom.equalTo(contForGoodAt).offset(-KDefaultPadding)
        })
        someL.font = UIFont.systemFont(ofSize: 15)
        someL.numberOfLines = 0
        someL.lineBreakMode = NSLineBreakMode.byCharWrapping
        someL.textColor = UIColor.lightGray
        
        let youImgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
        youImgV.image = UIImage.init(named: "HC-you")
        contForGoodAt.addSubview(youImgV)
        youImgV.snp.updateConstraints({ (make) in
            make.centerY.equalTo(goodAtL)
            make.right.equalTo(contForGoodAt).offset(-KDefaultPadding)
        })
        
        
        ////// 简介
        containerV.addSubview(contForIntr)
        contForIntr.snp.updateConstraints { (make) in
            make.top.equalTo(contForGoodAt.snp.bottom)
            make.left.right.equalTo(containerV)
        }
        
        contForIntr.addSubview(introL)
        introL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(KDefaultPadding)
            make.top.equalTo(contForIntr)
            make.width.equalTo(40)
        }
        introL.text = "简介"
        introL.textColor = UIColor.lightGray
        introL.font = UIFont.systemFont(ofSize: 17)
        
        contForIntr.addSubview(introDetail)
        introDetail.snp.updateConstraints({ (make) in
            make.top.equalTo(contForIntr).offset(5)
            make.left.equalTo(introL.snp.right).offset(KDefaultPadding)
            make.width.equalTo(Int(SCREEN_WIDTH) - KDefaultPadding * 4 - 55)
            make.bottom.equalTo(contForIntr).offset(-KDefaultPadding)
        })
        introDetail.numberOfLines = 0
        introDetail.lineBreakMode = NSLineBreakMode.byCharWrapping
        introDetail.textColor = UIColor.lightGray
        introDetail.font = UIFont.systemFont(ofSize: 15)
        
        let youImgV02 = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
        youImgV02.image = UIImage.init(named: "HC-you")
        contForIntr.addSubview(youImgV02)
        youImgV02.snp.updateConstraints({ (make) in
            make.centerY.equalTo(introL)
            make.right.equalTo(contForIntr).offset(-KDefaultPadding)
        })
        
        let introTapG = UITapGestureRecognizer.init(target: self, action: #selector(headViewForD.editIntro))
        contForIntr.addGestureRecognizer(introTapG)
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(contForIntr.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(1)
            make.bottom.equalTo(containerV)
        }
        divisionV.backgroundColor = kdivisionColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension headViewForD {
    @objc func editIntro(){
        HCPrint(message: "editIntro")
        if let introBlock = introBlock {
            introBlock()
        }
    }
    
    @objc func editGoodat(){
        HCPrint(message: "editGoodat")
        if let goodatBlock = goodatBlock {
            goodatBlock()
        }
    }
}
