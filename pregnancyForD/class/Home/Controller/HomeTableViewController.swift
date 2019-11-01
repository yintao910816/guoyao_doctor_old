//
//  HomeTableViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
import SVProgressHUD

class HomeTableViewController: BaseTableViewController {

    let reuseIdentifier = "reuseIdentifier"
    
    var consultArray : [ConsultModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var hasNext : Bool = true
    
    var pageNo : NSInteger = 1
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "消息"
        
        self.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let headerV = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadNewData))
        headerV?.setTitle("下拉刷新", for: .idle)
        headerV?.setTitle("松手刷新", for: .pulling)
        headerV?.setTitle("即将刷新", for: .willRefresh)
        headerV?.setTitle("正在请求", for: .refreshing)
        tableView.mj_header = headerV
        
        let footerV = MJRefreshAutoStateFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadMoreData))
        footerV?.setTitle("上拉加载", for: .pulling)
        footerV?.setTitle("松手刷新", for: .willRefresh)
        footerV?.setTitle("正在请求", for: .refreshing)
        footerV?.setTitle("拖动请求数据", for: .idle)
        footerV?.setTitle("已加载全部数据", for: .noMoreData)
        tableView.mj_footer = footerV
        
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 60, bottom: 0, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.loadNewData), name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.loadNewData), name: NSNotification.Name.init(RejectConsultSuccess), object: nil)
        
        tableView.mj_header.beginRefreshing()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consultArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HomeTableViewCell
        cell.consultModel = consultArray?[indexPath.row]
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testVC = TestViewController()
        testVC.patientId = consultArray?[indexPath.row].patientId
        testVC.doctorId = consultArray?[indexPath.row].doctorId
        testVC.identityNo = consultArray?[indexPath.row].identityNo
        self.navigationController?.pushViewController(testVC, animated: true)
    }
}

extension HomeTableViewController{
    @objc func loadNewData(){
        pageNo = 1
        hasNext = true
        consultArray = nil
        
        tableView.mj_header.endRefreshing()
        requestData()
    }

    @objc func loadMoreData(){
        tableView.mj_footer.endRefreshing()
        requestData()
    }
        
    func requestData(){
        guard hasNext == true else{
            HCShowError(info: "已加载全部信息")
            return
        }
        
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_getConsultList((UserManager.shareIntance.currentUser?.token)!, pageNum: pageNo, pageSize: 10) { [weak self](success, arr, hasNext, msg) in
            if success == true {
//                self?.updateBadgenumber()
                self?.pageNo += 1
                self?.hasNext = hasNext
                if let preArr = self?.consultArray {
                    let totalArr = preArr + arr!
                    self?.consultArray = totalArr
                }else{
                    self?.consultArray = arr
                }
                SVProgressHUD.dismiss()
            }else{
                HCShowError(info: msg)
            }
        }
        
    }
}
    

//extension HomeTableViewController {
//    func updateBadgenumber(){
//        HttpRequestManager.shareIntance.unReplyCount((UserManager.shareIntance.currentUser?.token)!, callback: { [unowned self](success, num) in
//            if success == true {
//                if num != 0 {
//                    self.navigationController?.tabBarItem.badgeValue = String.init(format: "%d", num)
//                }else{
//                    self.navigationController?.tabBarItem.badgeValue = nil
//                }
//            }
//        })
//    }
//}

