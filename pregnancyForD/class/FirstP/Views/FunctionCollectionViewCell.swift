//
//  FunctionCollectionViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class FunctionCollectionViewCell: UICollectionViewCell {
    
    lazy var imgV : UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        return i
    }()
    lazy var titleL : UILabel = {
        let t = UILabel()
        t.font = UIFont.init(name: kReguleFont, size: kTextSize + 2)
        t.textColor = kTextColor
        return t
    }()
    lazy var detailL : UILabel = {
        let d = UILabel()
        d.font = UIFont.init(name: kReguleFont, size: kTextSize - 3)
        d.textColor = kLightTextColor
        return d
    }()
    
    
    var model : HomeFunctionModel?{
        didSet{
            if let model = model{
                if let p = model.path{
                    imgV.HC_setImageFromURL(urlS: p, placeHolder: "手术计划")
                }
                titleL.text = model.name
                detailL.text = model.remark
                
                if let name = model.name{
                    switch name{
                    case "手术计划":
                        titleL.textColor = UIColor.init(red: 88/255.0, green: 194/255.0, blue: 208/255.0, alpha: 1)
                    case "在线咨询":
                        titleL.textColor = UIColor.init(red: 236/255.0, green: 134/255.0, blue: 146/255.0, alpha: 1)
                    case "运营数据":
                        titleL.textColor = UIColor.init(red: 139/255.0, green: 196/255.0, blue: 90/255.0, alpha: 1)
                    case "患者管理":
                        titleL.textColor = UIColor.init(red: 229/255.0, green: 178/255.0, blue: 71/255.0, alpha: 1)
                    default:
                        titleL.textColor = kDefaultThemeColor
                    }
                }
            }
        }
    }
    
    var space : CGFloat? {
        didSet{
            if let i = space{
                if i == 1{
                    let offY = CellHeight * 0.5
                    
                    detailL.snp.updateConstraints { (make) in
                        make.top.equalTo(self.snp.centerY).offset(i - offY)
                        make.left.equalTo(self).offset(20)
                    }
                    
                    titleL.snp.updateConstraints { (make) in
                        make.left.equalTo(detailL)
                        make.bottom.equalTo(self.snp.centerY).offset(-i - offY)
                    }
                    
                    
                    let ratio : CGFloat = 0.8
                    let w = frame.size.height * ratio
                    imgV.snp.updateConstraints { (make) in
                        make.right.bottom.equalTo(self)
                        make.height.equalTo(w)
                        make.width.equalTo(w)
                    }
                }else{
                    detailL.snp.updateConstraints { (make) in
                        make.top.equalTo(self.snp.centerY).offset(2)
                        make.left.equalTo(self).offset(20)
                    }
                    
                    titleL.snp.updateConstraints { (make) in
                        make.left.equalTo(detailL)
                        make.bottom.equalTo(self.snp.centerY).offset(-2)
                    }
                    
                    
                    let ratio : CGFloat = 0.9
                    let w = frame.size.height * ratio
                    imgV.snp.updateConstraints { (make) in
                        make.right.bottom.equalTo(self)
                        make.height.equalTo(w)
                        make.width.equalTo(w)
                    }
                }
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(imgV)
        self.addSubview(titleL)
        self.addSubview(detailL)
        
        detailL.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(2)
            make.left.equalTo(self).offset(20)
        }
        
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(detailL)
            make.bottom.equalTo(self.snp.centerY).offset(-2)
        }
        
        
        let ratio : CGFloat = 0.9
        let w = frame.size.height * ratio
        imgV.snp.updateConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.height.equalTo(w)
            make.width.equalTo(w)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
