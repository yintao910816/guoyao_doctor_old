//
//  HomeFunctionView.swift
//  aileyun
//
//  Created by huchuang on 2017/8/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD


class HomeFunctionModule: NSObject {
    
    weak var naviVC : UINavigationController?
    
    var modelArr : [HomeFunctionModel]?{
        didSet{
            if let arr = modelArr {
                if arr.count % 2 == 0{
                    isOdd = false
                }
                collectionV.reloadData()
                
                updateSize(arr.count)
            }
        }
    }
    
    // 奇数
    var isOdd : Bool = true {
        didSet{
            if isOdd == false{
                self.layout.firstSectionItems = [[0], [1]]
            }
        }
    }
    
    lazy var layout : CustomSizeFlowLayout = {
        let l = CustomSizeFlowLayout.init()
        l.firstSectionItems = [[0], [1, 2]]
        l.sectionItems = [[0], [1]]
        return l
    }()

    lazy var collectionV : UICollectionView = {
        let collectV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CellHeight * 3), collectionViewLayout: self.layout)
        collectV.backgroundColor = UIColor.clear
        
        collectV.isScrollEnabled = false
        
        collectV.delegate = self
        collectV.dataSource = self
        
        return collectV
    }()
    
    let collectionReuseI = "collectionReuseI"
    
    override init() {
        super.init()
        
        collectionV.register(FunctionCollectionViewCell.self, forCellWithReuseIdentifier: collectionReuseI)
    }

    
    convenience init(collectF : CGRect) {
        self.init()
        
        collectionV.frame = collectF
    }
    
    
    func updateSize(_ count : NSInteger){
        var layer : NSInteger!
        if count % 2 == 0 {
            layer = (count - 1) / 2 + 1
        }else{
            layer = count / 2 + 1
        }
        let frame = collectionV.frame
        collectionV.frame = CGRect.init(x: 0, y: frame.origin.y, width: SCREEN_WIDTH, height: CellHeight * CGFloat(layer))
    }
    
    
    func actionWithModel(model : HomeFunctionModel){
        HCPrint(message: "click")
        if let u = model.url{
            if u == "CONSULT_ONLINE"{
                let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                tabVC.selectedIndex = 1
            }else if u == "PATIENT_MANANGER"{
                let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                tabVC.selectedIndex = 2
            }else if u.contains("http"){
                let webV = WebViewController()
                webV.url = u
                let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                let naviVC = tabVC.selectedViewController as! UINavigationController
                naviVC.pushViewController(webV, animated: true)
            }
        }
    }
}




extension HomeFunctionModule : CustomSizeDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewFlowLayout: CustomSizeFlowLayout, widthForSectionAtColumn column: Int) -> CGFloat {
        let sectionItemCount: CGFloat = CGFloat(collectionViewFlowLayout.sectionItems.count)
        let width = (collectionView.bounds.size.width - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.sectionInset.right - DefaultGap) / sectionItemCount
        return width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewFlowLayout: CustomSizeFlowLayout, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        if isOdd == true {
            if indexPath.row  == 0 {
                return CellHeight * 2
            }else{
                return CellHeight - 0.5
            }
        }else{
            return CellHeight
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseI, for: indexPath) as! FunctionCollectionViewCell
        cell.model = modelArr?[indexPath.row]
        
        // 奇数时调整文字间距
        if isOdd == true {
            if indexPath.row == 0{
                cell.space = 1
            }else{
                cell.space = 2
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelArr?[indexPath.row]
        if let model = model {
            actionWithModel(model: model)
        }
    }
}
