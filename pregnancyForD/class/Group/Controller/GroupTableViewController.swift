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
        
    }
    
    
    var numArray = [NSInteger]()
    
    var tableviewArray = [AnyObject]()
    
    lazy var searchBarV : UIView = {
        let s = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        let searchBtn = UIButton.init(frame: CGRect.init(x: 2, y: 2, width: SCREEN_WIDTH - 4, height: 40))
        searchBtn.setImage(UIImage.init(named: "HC-search"), for: UIControlState.normal)
        searchBtn.setTitle("搜索患者", for: UIControlState.normal)
        searchBtn.setTitleColor(UIColor.darkText, for: .normal)
        searchBtn.layer.cornerRadius = 20
        searchBtn.layer.borderColor = kdivisionColor.cgColor
        searchBtn.layer.borderWidth = 1
        searchBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
        searchBtn.addTarget(self, action: #selector(GroupTableViewController.searchVC), for: .touchUpInside)
        s.addSubview(searchBtn)
        return s
    }()
    
//    var selected = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "患者"
        
        let headerV = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(GroupTableViewController.requestData))
        headerV?.setTitle("下拉刷新", for: .idle)
        headerV?.setTitle("释放更新", for: .pulling)
        headerV?.setTitle("加载中...", for: .refreshing)
        tableView.mj_header = headerV
        
        tableView.tableHeaderView = searchBarV
        
        if UserManager.shareIntance.currentUser?.isMemb == false {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "分组管理", style: .done, target: self, action: #selector(GroupTableViewController.groupManager))
        }
        
        self.tableView.register(GroupTitleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(UINib.init(nibName: "GroupTitleTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.register(GroupPatientTableViewCell.self, forCellReuseIdentifier: reuseIdentifierP)
        self.tableView.register(UINib.init(nibName: "GroupPatientTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierP)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupTableViewController.requestData), name: NSNotification.Name.init(UpdatePatientInfo), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupTableViewController.requestData), name: NSNotification.Name.init(AddGroupSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupTableViewController.requestData), name: NSNotification.Name.init(RemoveGroupSuccess), object: nil)
        
        tableView.mj_header.beginRefreshing()
    }
    
    func searchVC(){
        let searchVC = SearchPatiViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
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
        return tableviewArray.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = tableviewArray[indexPath.row]
       
        if rowData.classForCoder != PatientModel.self{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GroupTitleTableViewCell
            cell.tagGroupModel = rowData as! TagGroupModel
            return cell
        }else{
            let pCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierP, for: indexPath) as! GroupPatientTableViewCell
            pCell.patientModel = rowData as! PatientModel
            return pCell
        }

    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowData = tableviewArray[indexPath.row]
        
        if rowData.classForCoder != PatientModel.self{
            return 44
        }else{
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = tableviewArray[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.isKind(of: GroupTitleTableViewCell.self))!{
            let titleCell = cell as! GroupTitleTableViewCell
            
            if titleCell.foldBtn.isSelected == true{   //删除对应分组
                titleCell.foldBtn.isSelected = false
                
                //保存状态
                let tempData = data as! TagGroupModel
                tempData.isSelected = false
        
                let t = tempData.total ?? 0
                guard t > 0 else{return}
                
                if t <= 15{
                    var indexPathArray = [IndexPath]()
                    for i in 0..<t{
                        indexPathArray.append(IndexPath.init(row: indexPath.row + i + 1, section: 0))
                        tableviewArray.remove(at: indexPath.row + 1)
                    }
                    //tableView视图更新
                    tableView.beginUpdates()
                    tableView.deleteRows(at: indexPathArray, with: UITableViewRowAnimation.top)
                    tableView.endUpdates()
                }else{
                    //过多的删掉
                    for i in 15..<t{
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
                        tableView.deleteRows(at: indexPathArray, with: UITableViewRowAnimation.top)
                        tableView.endUpdates()
                    })
                }
                
            }else{ //展示对应分组
                let tempData = data as! TagGroupModel
                guard tempData.total != 0 else {
                    HCShowError(info: "此分组没有患者！")
                    return
                }
                titleCell.foldBtn.isSelected = true
                
                // 保存状态
                tempData.isSelected = true
                
                guard tempData.tagName != "默认分组" else{
                    if let PatientArray = PatientArray {
                        var indexPathArray = [IndexPath]()
                        var tempRow = 0
                        for i in PatientArray{
                            if i.tagName == "" || i.tagName == nil{
                                tableviewArray.insert(i, at: indexPath.row + 1)
                                indexPathArray.append(IndexPath.init(row: indexPath.row + 1 + tempRow, section: 0))
                                tempRow = tempRow + 1
                            }
                        }
                        tableView.beginUpdates()
                        tableView.insertRows(at: indexPathArray, with: UITableViewRowAnimation.top)
                        tableView.endUpdates()
                    }
                    return
                }
                
                if let PatientArray = PatientArray {
                    var indexPathArray = [IndexPath]()
                    var tempRow = 0
                    for i in PatientArray{
                        if i.tagName == tempData.tagName{
                            tableviewArray.insert(i, at: indexPath.row + 1)
                            indexPathArray.append(IndexPath.init(row: indexPath.row + 1 + tempRow, section: 0))
                            tempRow = tempRow + 1
                        }
                    }
                    tableView.beginUpdates()
                    tableView.insertRows(at: indexPathArray, with: UITableViewRowAnimation.top)
                    tableView.endUpdates()
                }
            }
        }else{
            //GroupPatientTableViewCell
            let tempData = data as! PatientModel
            
            let testVC = TestViewController()
            testVC.patientId = tempData.p_id
            testVC.doctorId = tempData.doctorid
            self.navigationController?.pushViewController(testVC, animated: true)
        }
    }
}

extension GroupTableViewController{
    
    func groupManager(){
        let GroupMTVC = GroupManagerController()
        GroupMTVC.forSelector = false
        self.navigationController?.pushViewController(GroupMTVC, animated: true)
    }

    //请求数据
    func requestData() {
        self.tableView.mj_header.endRefreshing()
        
        SVProgressHUD.show()

        HttpRequestManager.shareIntance.HC_getPatientList((UserManager.shareIntance.currentUser?.token)!) { [unowned self](success, groupArr, message) in
            if success == true {
                SVProgressHUD.dismiss()
                self.GroupArray = groupArr
            }else{
                HCShowError(info: message)
            }
        }


    }
    
    func initPatientCount(){
        if let PatientArray = PatientArray {
            if let GroupArray = GroupArray {
                //删除之前的数据
                tableviewArray = [AnyObject]()
                numArray = [NSInteger]()
                
                //每一组计数
                for g in GroupArray {
                    var i = 0
                    for p in PatientArray {
                        if p.tagName == g.tagName {
                            i = i + 1
                        }
                    }
                    numArray.append(i)
                }
                //默认分组  插入到第一位
                var j = 0
                for p in PatientArray {
                    if p.tagName == "" || p.tagName == nil {
                        j = j + 1
                    }
                }
                numArray.insert(j, at: 0)
                
                let defaultGroup = TagGroupModel()
                defaultGroup.tagName = "默认分组"
                defaultGroup.total = numArray[0]
                tableviewArray.append(defaultGroup)
                
                for i in 0..<GroupArray.count{
                    let j = GroupArray[i]
                    j.total = numArray[i + 1]
                    tableviewArray.append(j)
                }
                tableView.reloadData()
            }
        }
    }
}
