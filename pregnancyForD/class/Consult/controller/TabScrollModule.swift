//
//  TabScrollModule.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/11/15.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class TabScrollModule: NSObject {
    lazy var segmentV : UIView = {
        let s = UIView.init()
        s.layer.borderWidth = 1
        s.layer.borderColor = kDefaultThemeColor.cgColor
        return s
    }()
    
    var selectedBtn = UIButton()
    
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
    
    var currentIndex : CGFloat?{
        didSet{
            if let i = currentIndex{
                for b in btnArr {
                    if b.tag == Int(i){
                        selectedBtn.isSelected = false
                        b.isSelected = true
                        selectedBtn = b
                    }
                }
                moveIndicateV()
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(titles : [String], imgs : [String], titleF : CGRect, views : [UIView], scrollF : CGRect, positionBlock : (UIView, UIView)->()) {
        self.init()
        guard titles.count == views.count && titles.count == imgs.count else{
            HCPrint(message: "你有病啊，瞎传参数")
            return
        }
        
        initScrollV(views, scrollF)
        
        initBtnArr(titles, imgs, titleF)
        
        positionBlock(segmentV, scrollV)
    }
    
    func initBtnArr(_ titles : [String],_ imgs : [String], _ titleF : CGRect){
        segmentV.frame = titleF
        segmentV.layer.cornerRadius = titleF.height / 2
        
        let w = titleF.width / CGFloat(titles.count)
        let h = titleF.height - 4
        indicateV.frame = CGRect.init(x: 2, y: 2, width: w - 4, height: h)
        indicateV.layer.cornerRadius = h / 2
        segmentV.addSubview(indicateV)
        
        for (index, t) in titles.enumerated() {
            let b = UIButton.init(frame: CGRect.init(x: w * CGFloat(index), y: 0, width: w, height: titleF.height))
            b.setTitle(t, for: .normal)
            b.setTitleColor(kDefaultThemeColor, for: .normal)
            b.setTitleColor(UIColor.white, for: .selected)
            b.setImage(UIImage.init(named: imgs[index] + "-red"), for: .normal)
            b.setImage(UIImage.init(named: imgs[index] + "-white"), for: .selected)
            b.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
            b.addTarget(self, action: #selector(TabScrollModule.btnClick), for: .touchDown)
            b.adjustsImageWhenHighlighted = false
            b.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
            b.tag = index
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
        guard sender.isSelected == false else {
            return
        }
        selectedBtn.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
        
        segmentIndex = CGFloat(sender.tag)
    }
    
    
    func moveIndicateV(){
        let i = selectedBtn.tag
        let h = indicateV.frame.height
        let w = indicateV.frame.width
        let width = selectedBtn.frame.width
        let x = CGFloat(i) * width + 2
        UIView.animate(withDuration: 0.1, animations: {
            self.indicateV.frame = CGRect.init(x: x, y: 2, width: w, height: h)
        })
    }
}

extension TabScrollModule : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pauseScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pauseScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            pauseScroll()
        }
    }
    
    func pauseScroll(){
        let offsetX = scrollV.contentOffset.x
        let index = offsetX / SCREEN_WIDTH
        
        if currentIndex != index {
            currentIndex = index
        }
    }
}
