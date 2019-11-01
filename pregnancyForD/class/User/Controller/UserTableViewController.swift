//
//  UserTableViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class UserTableViewController: BaseTableViewController {
    let reuseIdentifierC = "reuseIdentifier"
    
    lazy var headView : headViewForD = {
        let h = headViewForD.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 350))
        h.introBlock = {[unowned self]() in
            let introEditVC = EditViewController()
            introEditVC.isEditIntro = true
            introEditVC.infoString = self.userModel?.brief
            self.navigationController?.pushViewController(introEditVC, animated: true)
        }
        h.goodatBlock = {[unowned self]() in
            HCShowInfo(info: "功能暂不开放！")
        }
        return h
    }()
    
    var userModel : UserModel? {
        didSet{
            headView.userModel = userModel
            tableView.reloadData()
        }
    }
    
    var billURL : String?
    
    lazy var animator = PopoverAnimator()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人"
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .grouped)
        
        self.tableView.backgroundColor = kLightGrayColor
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 350
        
        let headerV = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(UserTableViewController.requestData))
        headerV?.setTitle("下拉刷新", for: .idle)
        headerV?.setTitle("释放更新", for: .pulling)
        headerV?.setTitle("加载中...", for: .refreshing)
        tableView.mj_header = headerV
        
        
        self.tableView.register(UserSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifierC)
        self.tableView.register(UINib.init(nibName: "UserSetTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierC)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "setting"), style: .plain, target: self, action: #selector(UserTableViewController.userSetting))
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserTableViewController.requestData), name: NSNotification.Name.init(ModifyDoctorIntro), object: nil)
        
//        if UserManager.shareIntance.currentUser?.isMemb == true{
//            tableView.allowsSelection = false
//        }
        
        initFooterView()
        
        tableView.mj_header.beginRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userModel != nil{
            return 1
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierC, for: indexPath)
        let cellTemp = cell as! UserSetTableViewCell
        
        if row == 0 {
            cellTemp.titleLabel.text = "分组管理"
            cellTemp.informationL.text = ""
        }else if row == 1 {
            cellTemp.titleLabel.text = "个人账单"
            cellTemp.informationL.text = ""
        }else {
            cellTemp.titleLabel.text = "绑定微信"
            cellTemp.informationL.text = "绑定后可以提现到微信账户"
//            if userModel?.feeCount != "" && userModel?.feeCount != nil{
//                let numS = userModel?.feeCount
//                let totalC = (numS?.characters.count)! - 4
//                var starS = ""
//                for i in 0..<totalC{
//                    starS = starS + "*"
//                }
//                let index = numS?.index((numS?.endIndex)!, offsetBy: -4)
//                let suffixS = numS?.substring(from: index!)
//                
//                cellTemp.informationL.text = starS + suffixS!
//            }else{
//                cellTemp.informationL.text = ""
//            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headView
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(GroupManagerController(), animated: true)
        }else if indexPath.row == 1{
            if let u = billURL{
                let webV = WebViewController()
                webV.url = u
                self.navigationController?.pushViewController(webV, animated: true)
            }
        }else{
            self.navigationController?.pushViewController(CountViewController(), animated: true)
        }
    }
    
}

extension UserTableViewController {
   
    @objc func userSetting(){
        let settingVC = SettingTableViewController()
        
        settingVC.modalPresentationStyle = .custom
        
        let space = AppDelegate.shareIntance.space
        
        animator.presentedFrame = CGRect(x: SCREEN_WIDTH - 180, y: space.topSpace + 50, width: 170, height: 200)
        settingVC.transitioningDelegate = animator
        
        settingVC.feedbackBlock = {[unowned self]()in
            let vc = EditViewController()
            vc.isFeedback = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        settingVC.shareBlock = {[weak self]()in
//            let vc = ShowShareViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
            HCShowInfo(info: "功能暂不开发")
        }
        
        self.present(settingVC, animated: true) { 
            //
        }
        
    }
    
    func initFooterView(){
        let footContainerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        let logoutBtn = UIButton()
        footContainerV.addSubview(logoutBtn)
        
        self.tableView.tableFooterView = footContainerV
        
        logoutBtn.frame = CGRect.init(x: 30, y: 20, width: SCREEN_WIDTH - 60, height: 40)
        logoutBtn.setTitle("注销", for: .normal)
        logoutBtn.backgroundColor = kDefaultThemeColor
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.addTarget(self, action: #selector(UserTableViewController.logout), for: .touchUpInside)
        
        let infoDic = Bundle.main.infoDictionary
        let currentVersion = infoDic?["CFBundleShortVersionString"] as! String
        let versionL = UILabel()
        versionL.text = "当前版本号：" + currentVersion
        footContainerV.addSubview(versionL)
        versionL.snp.updateConstraints { (make) in
            make.top.equalTo(logoutBtn.snp.bottom).offset(10)
            make.centerX.equalTo(footContainerV)
        }
        versionL.textColor = UIColor.lightGray
        versionL.sizeToFit()
    }

}

extension UserTableViewController {
    @objc func requestData(){
        self.tableView.mj_header.endRefreshing()
        
         SVProgressHUD.show()
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup.init()
        
        let token = UserManager.shareIntance.currentUser?.token ?? ""
        
        queue.async(group: group, qos: .default, flags: []) {
            //请求患者资料H5地址
            HttpRequestManager.shareIntance.HC_getH5URL(token: token, keyCode: "DOCTOT_BILL") { [weak self](success, info) in
                if success == true {
                    self?.billURL = info
//                    HCPrint(message: info)
                }else{
//                    HCShowError(info: info)
                }
            }
        }
        
        queue.async(group: group, qos: .default, flags: []) {
            HttpRequestManager.shareIntance.getUserInfo((UserManager.shareIntance.currentUser?.token)!) { [unowned self](success, model, message) in
                if success == true {
                    self.userModel = model
                }else{
                    HCShowError(info: message)
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            SVProgressHUD.dismiss()
        }
       
    }
    
    @objc func logout(){
        let alertController = UIAlertController(title: "提示信息",
                                                message: "您现在要退出登录吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {(action)->() in
            UserManager.shareIntance.logout()
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
