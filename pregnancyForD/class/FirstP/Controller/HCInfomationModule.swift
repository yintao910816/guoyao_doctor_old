//
//  HCInfomationModule.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/1/10.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class HCInfomationModule: NSObject {
    
    let tableV = UITableView.init()
    
    let notiTableV = UITableView.init()
    
    var modelArr : [ConsultMessageModel]?{
        didSet{
            if let arr = modelArr{
                if arr.count > 0{
                    tableV.reloadData()
                    tableV.tableHeaderView = UIView()
                }else{
                    tableV.tableHeaderView = getNoDataView()
                }
            }
        }
    }
    
    var notiArr : [NotificationModel]?{
        didSet{
            if let arr = modelArr{
                if arr.count > 0{
                    notiTableV.reloadData()
                    notiTableV.tableHeaderView = UIView()
                }else{
                    notiTableV.tableHeaderView = getNoDataView()
                }
            }
        }
    }
    
    var notiURL : String?
    
    let reuseIdentifier = "reuseIdentifier"
    let notiReuseIdentifier = "notiReuseIdentifier"
    
    override init() {
        super.init()
        
        tableV.dataSource = self
        tableV.delegate = self
        tableV.bounces = false
        tableV.isScrollEnabled = false
        tableV.tableFooterView = UIView()
        
        notiTableV.dataSource = self
        notiTableV.delegate = self
        notiTableV.bounces = false
        notiTableV.isScrollEnabled = false
        notiTableV.tableFooterView = UIView()
        
        tableV.register(HCInformationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        notiTableV.register(HCNoticeTableViewCell.self, forCellReuseIdentifier: notiReuseIdentifier)
    }
    
    func getNoDataView()->UIView{
        let v = UIView.init()
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 280)
        v.backgroundColor = kDefaultTabBarColor
        let imgV = UIImageView.init(image: UIImage.init(named: "noData"))
        imgV.contentMode = .center
        v.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalTo(v)
        }
        return v
    }

}

extension HCInfomationModule : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableV == tableView{
            let c = modelArr?.count ?? 0
            return c > 4 ? 4 : c
        }else{
            let c = notiArr?.count ?? 0
            return c > 4 ? 4 : c
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableV == tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HCInformationTableViewCell
            cell.model = modelArr?[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: notiReuseIdentifier, for: indexPath) as! HCNoticeTableViewCell
            cell.model = notiArr?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableV == tableView{
            let testVC = TestViewController()
            testVC.patientId = modelArr?[indexPath.row].patientId
            testVC.doctorId = modelArr?[indexPath.row].doctorId
            testVC.identityNo = modelArr?[indexPath.row].identityNo
            let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            let naviVC = tabVC.selectedViewController as! UINavigationController
            naviVC.pushViewController(testVC, animated: true)
        }else{
            if let u = notiURL{
                let m = notiArr![indexPath.row]
                if let id = m.id{
                    let webV = WebViewController()
                    webV.url = String.init(format: "%@?noticeId=%@", u, id)
                    let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                    let naviVC = tabVC.selectedViewController as! UINavigationController
                    naviVC.pushViewController(webV, animated: true)
                }
            }
        }
    }
}
