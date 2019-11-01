//
//  FirstPageViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/1/5.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class FirstPageViewController: BaseViewController {    //  谭丽华
    
    lazy var scrollV : UIScrollView = {
        let s = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 48))
        s.backgroundColor = kdivisionColor
        return s
    }()
    
    lazy var picScrollV : topView = {
        let t = topView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: scrollPicHeight))
        t.naviCtl = self.navigationController
        t.autoScrollTimeInterval = 3
        return t
    }()
    
    lazy var functionM : HomeFunctionModule = {
        let m = HomeFunctionModule.init(collectF: CGRect.init(x: 0, y: scrollPicHeight, width: SCREEN_WIDTH, height: CellHeight * 3 - 2))
        return m
    }()
    
    var howManyLayer : CGFloat = 1{
        didSet{
            HCPrint(message: howManyLayer)
        }
    }
    
    var tabScrollM : HCTabScrollModule?
    
    lazy var consultM : HCInfomationModule = {
        let h = HCInfomationModule()
        return h
    }()
    
    let contV = UIView.init(frame:  CGRect.init(x: 0, y: scrollPicHeight + CellHeight * 3, width: SCREEN_WIDTH, height: 40))

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "首页"
        
        initUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstPageViewController.requestData), name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FirstPageViewController.requestData), name: NSNotification.Name.init(RejectConsultSuccess), object: nil)
        
        scrollV.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func requestData(){
        scrollV.mj_header.endRefreshing()
        
        SVProgressHUD.show()
        
        let token = UserManager.shareIntance.currentUser?.token ?? ""
        
        let group = DispatchGroup.init()
        
        group.enter()
        HttpRequestManager.shareIntance.HC_bannerList(token: token) { [weak self](bool, arr) in
            if bool == true{
                self?.picScrollV.dataArr = arr
            }else{
                HCPrint(message: "banner为空")
            }
            group.leave()
        }
        
        group.enter()
        HttpRequestManager.shareIntance.HC_functionList(token: token) { [weak self](bool, arr) in
            if bool == true{
                self?.functionM.modelArr = arr
                if let arr = arr {
                    let c = arr.count
                    if c % 2 == 0 {
                        self?.howManyLayer = CGFloat((c - 1) / 2 + 1)
                    }else{
                        self?.howManyLayer = CGFloat(c / 2 + 1)
                    }
                }
            }else{
                HCPrint(message: "functionList为空")
            }
            group.leave()
        }
        
        group.enter()
        HttpRequestManager.shareIntance.HC_dynamicList(token: token, pageNum: 1, pageSize: 10) { [weak self](bool, consultArr, notiArr) in
            if bool == true{
                self?.consultM.modelArr = consultArr
                self?.consultM.notiArr = notiArr
            }else{
                HCPrint(message: "dynamicList为空")
            }
            group.leave()
        }
        
        group.enter()
        HttpRequestManager.shareIntance.HC_getH5URL(token: token, keyCode: "NOTICE_DETAIL_URL_DOCTOR") { [weak self](success, info) in
            if success == true {
                self?.consultM.notiURL = info
            }else{
                HCShowError(info: info)
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {[weak self]()in
            SVProgressHUD.dismiss()
            self?.resizeView()
            
            self?.updateBadgenumber()
        }
    }
    
    func resizeView(){
        functionM.collectionV.frame =  CGRect.init(x: 0, y: scrollPicHeight, width: SCREEN_WIDTH, height: CellHeight * howManyLayer - 2)
        contV.frame = CGRect.init(x: 0, y: scrollPicHeight + CellHeight * howManyLayer, width: SCREEN_WIDTH, height: 41 + DynamicHeight)
        scrollV.contentSize = CGSize.init(width: 0, height: scrollPicHeight + CellHeight * howManyLayer + 41 + DynamicHeight)
    }
    
    func initUI(){
        
        self.view.addSubview(scrollV)
        
        //禁止自动调整offset
        if #available(iOS 11.0, *) {
            scrollV.contentInsetAdjustmentBehavior = .never
        } else {
        }
        
        scrollV.addSubview(picScrollV)
        scrollV.addSubview(functionM.collectionV)
        scrollV.addSubview(contV)
        contV.backgroundColor = UIColor.white
        
        let redV = UIView.init(frame: CGRect.init(x: 20, y: 15, width: 3, height: 10))
        redV.backgroundColor = kDefaultThemeColor
        contV.addSubview(redV)
        
        let dynamicL = UILabel()
        dynamicL.text = "今日动态"
        dynamicL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        dynamicL.textColor = kTextColor
        
        contV.addSubview(dynamicL)
        dynamicL.snp.updateConstraints { (make) in
            make.left.equalTo(redV.snp.right).offset(3)
            make.centerY.equalTo(redV)
        }
        
        
        let titleF = CGRect.init(x: 120, y: 0, width: SCREEN_WIDTH - 120, height: 40)
        let scrollF = CGRect.init(x: 0, y: 41, width: SCREEN_WIDTH, height: DynamicHeight)
        
        let t = HCTabScrollModule.init(titles: ["咨询信息", "院内公告"], titleF: titleF, views: [consultM.tableV, consultM.notiTableV], scrollF: scrollF) { [weak self](titleV, scrollV) in
            self?.contV.addSubview(titleV)
            self?.contV.addSubview(scrollV)
            
            let divisionV = UIView()
            divisionV.backgroundColor = kdivisionColor
            self?.contV.addSubview(divisionV)
            divisionV.snp.updateConstraints { (make) in
                make.left.right.equalTo(contV)
                make.top.equalTo(titleV.snp.bottom)
                make.height.equalTo(1)
            }
        }
        tabScrollM = t
        
        
        let headerV = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(FirstPageViewController.requestData))
        headerV?.setTitle("下拉刷新", for: .idle)
        headerV?.setTitle("松手刷新", for: .pulling)
        headerV?.setTitle("即将刷新", for: .willRefresh)
        headerV?.setTitle("正在请求", for: .refreshing)
        scrollV.mj_header = headerV
    }
}

extension FirstPageViewController {
    func updateBadgenumber(){
        HttpRequestManager.shareIntance.unReplyCount((UserManager.shareIntance.currentUser?.token)!, callback: {(success, num) in
            if success == true {
                let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                let navC = tabVC.children[1] as! UINavigationController
                
                if num != 0 {
                    navC.tabBarItem.badgeValue = String.init(format: "%d", num)
                }else{
                    navC.tabBarItem.badgeValue = nil
                }
            }
        })
    }
}

