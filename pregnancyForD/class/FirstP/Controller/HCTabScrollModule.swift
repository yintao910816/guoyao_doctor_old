//
//  TabScrollModule.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/11/15.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class HCTabScrollModule: NSObject {
    lazy var segmentV : UIView = {
        let s = UIView.init()
        return s
    }()
    
    var btnArr = [UIButton]()
    
    lazy var indicateV : UIView = {
        let i = UIView.init()
        i.backgroundColor = kDefaultThemeColor
        return i
    }()
    
    lazy var scrollV : UIScrollView = {
        let s = UIScrollView.init()
        s.bounces = false
        s.isPagingEnabled = true
        s.delegate = self
        return s
    }()
    
    var segmentIndex : CGFloat?{
        didSet{
            if let index = segmentIndex{
                scrollV.setContentOffset(CGPoint.init(x: index * scrollV.frame.width, y: 0), animated: true)
            }
        }
    }
    
    
    override init() {
        super.init()
    }
    
    convenience init(titles : [String], titleF : CGRect, views : [UIView], scrollF : CGRect, positionBlock : (UIView, UIView)->()) {
        self.init()
        guard titles.count == views.count else{
            HCPrint(message: "你有病啊，瞎传参数")
            return
        }
        
        initScrollV(views, scrollF)
        
        initBtnArr(titles, titleF)
        
        positionBlock(segmentV, scrollV)
        
        gradualChange(p: 0)
    }
    
    func initBtnArr(_ titles : [String], _ titleF : CGRect){
        segmentV.frame = titleF
        
        let w = titleF.width / CGFloat(titles.count)
        let h = titleF.height
        indicateV.frame = CGRect.init(x: 0, y: h - 3, width: w, height: 3)
        segmentV.addSubview(indicateV)
        
        for (index, t) in titles.enumerated() {
            let b = UIButton.init(frame: CGRect.init(x: w * CGFloat(index), y: 0, width: w, height: h))
            b.setTitle(t, for: .normal)
            b.setTitleColor(kTextColor, for: .normal)
            b.titleLabel?.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
            b.tag = index
            b.addTarget(self, action: #selector(btnClick), for: .touchDown)
            segmentV.addSubview(b)
            btnArr.append(b)
        }
    }
    
    
    func initScrollV(_ views : [UIView], _ scrollF : CGRect){
        scrollV.frame = scrollF
        for (index, i) in views.enumerated() {
            let x = CGFloat(index) * scrollF.width
            i.frame = CGRect.init(x: x, y: 0, width: scrollF.width, height: scrollF.height)
            scrollV.addSubview(i)
        }
        scrollV.contentSize = CGSize.init(width: scrollF.width * CGFloat(views.count), height: scrollF.height)
    }
    
    @objc func btnClick(sender : UIButton){
        segmentIndex = CGFloat(sender.tag)
    }
    
    func gradualChange(p : CGFloat){
        //indicateV   位置
        let h = indicateV.frame.height
        let w = indicateV.frame.width
        let x = p * w
        let y = indicateV.frame.origin.y
        indicateV.frame = CGRect.init(x: x, y: y, width: w, height: h)
        
        //按钮颜色
        let firstC = UIColor.init(red: 183/255.0 * (1-p), green: 161/255.0 * (1-p), blue: 133/255.0 * (1-p), alpha: 1)
        let secondC = UIColor.init(red: 183/255.0 * p, green: 161/255.0 * p, blue: 133/255.0 * p, alpha: 1)
        for b in btnArr{
            if b.tag == 0{
                b.setTitleColor(firstC, for: .normal)
            }else{
                b.setTitleColor(secondC, for: .normal)
            }
        }
    }
}

extension HCTabScrollModule : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let w = scrollView.frame.width
        let p = offsetX / w
        
        gradualChange(p: p)
    }
}
