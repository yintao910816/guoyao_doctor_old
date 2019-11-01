//
//  BaseChatTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/14.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class BaseChatTableViewCell: UITableViewCell {
    var showPhotoBlock : imgArrBlock?
    var convertBlock : ((_ p : CGPoint)->CGPoint)?
    
    var indexBlock : ((_ i : Int)->())?
    
    var cellCenter = CGPoint.zero
    var cellImage = UIImage.init()
    
    lazy var headImgV : UIImageView = {
        let h = UIImageView.init()
        h.layer.cornerRadius = 20
        h.clipsToBounds = true
        h.contentMode = .scaleAspectFill
        return h
    }()
    
    lazy var timeL : UILabel = {
        let t = UILabel.init()
        t.font = UIFont.init(name: kReguleFont, size: 14)
        t.textAlignment = NSTextAlignment.left
        return t
    }()
    
    lazy var contV : UIView = {
        let c = UIView.init()
        return c
    }()
    
    var viewModel : ConsultViewmodel?{
        
        didSet{
            headImgV.frame = viewModel?.headIVF ?? CGRect.zero
            timeL.frame = viewModel?.timeF ?? CGRect.zero
            contV.frame = viewModel?.contVF ?? CGRect.zero
            
            if contV.frame != CGRect.zero{
                if let arr = contV.layer.sublayers{
                    for s in arr{
                        s.removeFromSuperlayer()
                    }
                }
                if viewModel?.model?.isPati == "1"{
                    addLeftCornerPath(v: contV)
                }else{
                    addRightCornerPath(v: contV)
                }
            }
            
            if let imgS = viewModel?.model?.headImg{
                headImgV.HC_setImageFromURL(urlS: imgS, placeHolder: "HC-Dr-2")
            }else{
                headImgV.image = UIImage.init(named: "HC-Dr-2")
            }
            
            timeL.text = viewModel?.model?.createT
            
        }
    }
    
    func addLeftCornerPath(v : UIView){
        let rect = v.bounds
        
        let corner = UInt8(UIRectCorner.topRight.rawValue) | UInt8(UIRectCorner.bottomLeft.rawValue) |  UInt8(UIRectCorner.bottomRight.rawValue)
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: UIRectCorner(rawValue: UInt(corner)), cornerRadii: CGSize.init(width: 10, height: 10))
        
        addClipLayer(path: maskPath, v: v)
    }
    
    func addRightCornerPath(v : UIView){
        let rect = v.bounds
        
        let corner = UInt8(UIRectCorner.topLeft.rawValue) | UInt8(UIRectCorner.bottomLeft.rawValue) |  UInt8(UIRectCorner.bottomRight.rawValue)
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: UIRectCorner(rawValue: UInt(corner)), cornerRadii: CGSize.init(width: 10, height: 10))
        
        addClipLayer(path: maskPath, v: v)
    }

    func addClipLayer(path : UIBezierPath, v : UIView){
        let rect = v.bounds
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = rect
        maskLayer.path = path.cgPath
        maskLayer.strokeColor = UIColor.lightGray.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        
        v.layer.addSublayer(maskLayer)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(headImgV)
        
        self.addSubview(timeL)
        
        self.addSubview(contV)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension BaseChatTableViewCell : GetPhotoCenterDelegate {
//    func getPhotoCenter()->CGPoint{
//        return CGPoint.zero
//    }
//    
//    func getImage()->UIImage{
//        return UIImage.init()
//    }
}
