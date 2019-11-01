//
//  SettingTableViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/23.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class SettingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let tableV : UITableView = UITableView.init(frame: CGRect.init(x: 1, y: 6, width: 168, height: 193))

    let reuseIdentifier = "reuseIdentifier"
    
    var shareBlock : blankBlock?
    var feedbackBlock : blankBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImageV = UIImageView()
        
        let origImage = UIImage.init(named: "HC-jiaobiao-hui")
        let finalImage = origImage?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 20)
        backImageV.frame = CGRect.init(x: 0, y: 0, width: 170, height: 200)
        backImageV.image = finalImage
        
        self.view.insertSubview(backImageV, at: 0)
        
        self.view.addSubview(tableV)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.tableFooterView = UIView()
        tableV.layer.cornerRadius = 5
        
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let row = indexPath.row
        if row == 0 {
            let isReceive = UserDefaults.standard.value(forKey: kReceiveRemoteNote) as! Bool
            if isReceive == true{
                cell.textLabel?.text = "接收通知"
                cell.imageView?.image = UIImage.init(named: "bujieshou")
            }else{
                cell.textLabel?.text = "不接收通知"
                cell.imageView?.image = UIImage.init(named: "jieshou")
            }
        }else if row == 1 {
            cell.textLabel?.text = "意见反馈"
            cell.imageView?.image = UIImage.init(named: "yijianfankui")
        }else if row == 2 {
            cell.textLabel?.text = "app 分享"
            cell.imageView?.image = UIImage.init(named: "HC-fenxiang")
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            let isReceive = UserDefaults.standard.value(forKey: kReceiveRemoteNote) as! Bool
            if isReceive == false{
                UserDefaults.standard.set(true, forKey: kReceiveRemoteNote)
                UMessage.registerForRemoteNotifications()
                tableView.reloadData()
            }else{
                UserDefaults.standard.set(false, forKey: kReceiveRemoteNote)
                UMessage.unregisterForRemoteNotifications()
                tableView.reloadData()
            }

        }else if indexPath.row == 1 {
            self.dismiss(animated: false, completion: {[unowned self]()in
                if let feedbackBlock = self.feedbackBlock{
                    feedbackBlock()
                }
            })
        }else if indexPath.row == 2 {
            self.dismiss(animated: false, completion: {[unowned self]()in
                if let shareBlock = self.shareBlock {
                    shareBlock()
                }
            })
        }
    }
    
}
