//
//  GroupTableViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class GroupViewController: UIViewController {
    
    let reuseIdentifier = "reuseIdentifier"
    let reuseIdentifierP = "reuseIdentifierForP"
    
    
    var GroupArray : [GroupPatientModels]?{
        didSet{
            dealWithData(arr: GroupArray)
            tableviewArray = GroupArray!
            tableView.reloadData()
        }
    }
    
    var tableviewArray = [AnyObject]()
    
    lazy var searchBarV : UIView = {
        let s = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        let searchBtn = UIButton.init(frame: CGRect.init(x: 2, y: 2, width: SCREEN_WIDTH - 4, height: 40))
        searchBtn.setImage(UIImage.init(named: "HC-search"), for: .normal)
        searchBtn.setTitle("搜索患者", for: .normal)
        searchBtn.setTitleColor(UIColor.darkText, for: .normal)
        searchBtn.layer.cornerRadius = 20
        searchBtn.layer.borderColor = kdivisionColor.cgColor
        searchBtn.layer.borderWidth = 1
        searchBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
        searchBtn.addTarget(self, action: #selector(GroupViewController.searchVC), for: .touchUpInside)
        s.addSubview(searchBtn)
        return s
    }()
    
    
    lazy var tableView : UITableView = {
        let space = AppDelegate.shareIntance.space
        let r = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 92)
        let t = UITableView.init(frame: r)
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        self.view.addSubview(t)
        return t
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "患者"
        
        let headerV = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(GroupViewController.requestData))
        headerV?.setTitle("下拉刷新", for: .idle)
        headerV?.setTitle("释放更新", for: .pulling)
        headerV?.setTitle("加载中...", for: .refreshing)
        tableView.mj_header = headerV
        
        tableView.tableHeaderView = searchBarV
        
//        if UserManager.shareIntance.currentUser?.isMemb == false {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "分组管理", style: .done, target: self, action: #selector(GroupViewController.groupManager))
//        }
        
        tableView.register(GroupTitleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UINib.init(nibName: "GroupTitleTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        tableView.register(GroupPatientTableViewCell.self, forCellReuseIdentifier: reuseIdentifierP)
        tableView.register(UINib.init(nibName: "GroupPatientTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierP)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.requestData), name: NSNotification.Name.init(UpdatePatientInfo), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.requestData), name: NSNotification.Name.init(AddGroupSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.requestData), name: NSNotification.Name.init(RemoveGroupSuccess), object: nil)
    
        
        tableView.mj_header.beginRefreshing()
    }
    
    @objc func searchVC(){
        let searchVC = SearchPatiViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func dealWithData(arr : [GroupPatientModels]?){
        if let arr = arr{
            for i in arr{
                if let pArr = i.patientList{
                    for j in pArr{
                        let t = j as! PatientModel
                        t.doctorIds = i.doctorIds
                    }
                }
            }
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GroupViewController{
    
    @objc func groupManager(){
        let GroupMTVC = GroupManagerController()
        GroupMTVC.forSelector = false
        self.navigationController?.pushViewController(GroupMTVC, animated: true)
    }

    //请求数据
    @objc func requestData() {
        self.tableView.mj_header.endRefreshing()
        
        SVProgressHUD.show()

        HttpRequestManager.shareIntance.HC_getPatientList((UserManager.shareIntance.currentUser?.token)!) { [weak self](success, groupArr, message) in
            if success == true {
                SVProgressHUD.dismiss()
                self?.GroupArray = groupArr
            }else{
                HCShowError(info: message)
            }
        }
    }
    
}

extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = tableviewArray[indexPath.row]
        
        if rowData.classForCoder == GroupPatientModels.self{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GroupTitleTableViewCell
            cell.tagGroupModel = rowData as! GroupPatientModels
            return cell
        }else{
            let pCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierP, for: indexPath) as! GroupPatientTableViewCell
            pCell.model = rowData as! PatientModel
            return pCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowData = tableviewArray[indexPath.row]
        
        if rowData.classForCoder != GroupPatientModels.self{
            return 50
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = tableviewArray[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.isKind(of: GroupTitleTableViewCell.self))!{
            let titleCell = cell as! GroupTitleTableViewCell
            
            if titleCell.foldBtn.isSelected == true{   //删除对应分组
                titleCell.foldBtn.isSelected = false
                
                //保存状态
                let tempData = data as! GroupPatientModels
                tempData.isSelected = false
                
                let t = tempData.count
                guard t > 0 else{return}
                
                if t <= 15{
                    var indexPathArray = [IndexPath]()
                    for i in 0..<t{
                        indexPathArray.append(IndexPath.init(row: indexPath.row + i + 1, section: 0))
                        tableviewArray.remove(at: indexPath.row + 1)
                    }
                    //tableView视图更新
                    tableView.beginUpdates()
                    tableView.deleteRows(at: indexPathArray, with: .top)
                    tableView.endUpdates()
                }else{
                    //过多的删掉
                    for _ in 15..<t{
                        tableviewArray.remove(at: indexPath.row + 16)
                    }
                    tableView.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        //删除动态效果
                        var indexPathArray = [IndexPath]()
                        for i in 0..<15{
                            indexPathArray.append(IndexPath.init(row: indexPath.row + i + 1, section: 0))
                            self.tableviewArray.remove(at: indexPath.row + 1)
                        }
                        //tableView视图更新
                        tableView.beginUpdates()
                        tableView.deleteRows(at: indexPathArray, with: .top)
                        tableView.endUpdates()
                    })
                }
                
            }else{ //展示对应分组
                let tempData = data as! GroupPatientModels
                guard tempData.count > 0 else {
                    HCShowError(info: "此分组没有患者！")
                    return
                }
                titleCell.foldBtn.isSelected = true
                
                // 保存状态
                tempData.isSelected = true
                
                if let patiArr = tempData.patientList {
                    var indexPathArray = [IndexPath]()
                    var tempRow = 1
                    let arr = patiArr as! [PatientModel]
                    for i in arr{
                        tableviewArray.insert(i, at: indexPath.row + tempRow)
                        indexPathArray.append(IndexPath.init(row: indexPath.row + tempRow, section: 0))
                        tempRow = tempRow + 1
                    }
                    tableView.beginUpdates()
                    tableView.insertRows(at: indexPathArray, with: .top)
                    tableView.endUpdates()
                }
            }
        }else{
            //GroupPatientTableViewCell
            let tempData = data as! PatientModel
            
            let testVC = TestViewController()
            testVC.patientId = tempData.patientId
            testVC.doctorS = tempData.doctorIds
            testVC.identityNo = tempData.identityNo
            self.navigationController?.pushViewController(testVC, animated: true)
        }
    }
}
