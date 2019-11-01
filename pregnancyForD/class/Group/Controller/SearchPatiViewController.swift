//
//  SearchDocViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/29.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD    //林小丽    程学慧

class SearchPatiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    lazy var tableView : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - 44))
        t.tableFooterView = UIView.init()
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    let reuseIdentiForP = "reuseIdentiForP"
    let reuseIdentiForR = "reuseIdentiForR"
    
    lazy var patientArr : [SearchPatientModel] = [SearchPatientModel]()
    lazy var cycleArr : [SearchCycleModel] = [SearchCycleModel]()
    
    lazy var searchB : UISearchBar = {
        let s = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 40))
        s.placeholder = "搜索患者"
        s.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        s.delegate = self
        return s
    }()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = kDefaultThemeColor
        
        self.view.addSubview(tableView)
        
        setupNavibar()
        
        self.tableView.register(SearchPatientTableViewCell.self, forCellReuseIdentifier: reuseIdentiForP)
        self.tableView.register(SearchCycleTableViewCell.self, forCellReuseIdentifier: reuseIdentiForR)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchB.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchB.resignFirstResponder()
    }
    
    
    func setupNavibar(){
        let containV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 40))
        containV.layer.cornerRadius = 20
        containV.clipsToBounds = true
        containV.addSubview(searchB)
        self.navigationController?.navigationBar.autoresizesSubviews = false
        self.navigationItem.titleView = containV
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return patientArr.count
        }else{
            return cycleArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentiForP, for: indexPath) as! SearchPatientTableViewCell
            cell.model = patientArr[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentiForR, for: indexPath) as! SearchCycleTableViewCell
            cell.model = cycleArr[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard patientArr.count > 0 else{
                return UIView.init()
            }
            let c = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
            c.backgroundColor = UIColor.white
            let s = UIView.init(frame: CGRect.init(x: 0, y: 30, width: SCREEN_WIDTH, height: 1))
            s.backgroundColor = kdivisionColor
            let t = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 100, height: 30))
            t.text = "默认分组"
            t.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
            t.textColor = kLightTextColor
            c.addSubview(t)
            c.addSubview(s)
            return c
        }else{
            guard cycleArr.count > 0 else{
                return UIView.init()
            }
            let c = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
            c.backgroundColor = UIColor.white
            let s1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 2))
            s1.backgroundColor = kdivisionColor
            let s = UIView.init(frame: CGRect.init(x: 0, y: 29, width: SCREEN_WIDTH, height: 1))
            s.backgroundColor = kdivisionColor
            let t = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 100, height: 30))
            t.text = "更多结果"
            t.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
            t.textColor = kLightTextColor
            c.addSubview(t)
            c.addSubview(s1)
            c.addSubview(s)
            return c
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            guard patientArr.count > 0 else{
                return 0
            }
            return 30
        }else{
            guard cycleArr.count > 0 else{
                return 0
            }
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let tempData = patientArr[indexPath.row]
            let testVC = TestViewController()
            if let hasScheme = tempData.hasScheme{
                if hasScheme.intValue == 1{
                    testVC.identityNo = tempData.identityNo
                }
            }
            testVC.patientId = tempData.patientId
            testVC.doctorS = tempData.doctorIds
            self.navigationController?.pushViewController(testVC, animated: true)
        }else{
            let tempData = cycleArr[indexPath.row]
            let testVC = TestViewController()
            testVC.identityNo = tempData.identityNo
            if let p = tempData.patientId{
                if p != ""{
                    let i = Int(p)
                    testVC.patientId = NSNumber.init(value: i!)
                }
            }
            testVC.doctorS = tempData.doctorId
            self.navigationController?.pushViewController(testVC, animated: true)
        }
        
    }
}

extension SearchPatiViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count)! > 0{
            searchBar.setShowsCancelButton(true, animated: true)
            let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
            uiButton.setTitle("取消", for: .normal)
        }else{
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        HCPrint(message: "searchBarTextDidEndEditing")
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        HCPrint(message: "searchBarBookmarkButtonClicked")
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        HCPrint(message: "searchBarResultsListButtonClicked")
    } 
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchB.text != "" && searchB.text != nil else{
            HCShowError(info: "请输入患者名字")
            return
        }
        
        searchB.resignFirstResponder()
        
        searchTheName(name: searchB.text!)   //开始搜索
    }
    
    func searchTheName(name : String){
        
        SVProgressHUD.show()
        
        let token = UserManager.shareIntance.currentUser?.token ?? ""     // 孟洁  徐三云   林小丽   罗延琼
        
        HttpRequestManager.shareIntance.HC_findPatient(token: token, patientName: name) {[weak self](success, referArr, reproductArr) in
            SVProgressHUD.dismiss()
            if success == true{
                guard referArr.count > 0 || reproductArr.count > 0 else{
                    HCShowInfo(info: "没有找到对应的患者，请输入准确完整的名字")
                    return
                }
                self?.patientArr = referArr
                self?.cycleArr = reproductArr
                self?.tableView.reloadData()
            }else{
                HCShowError(info: "请求数据失败")
            }
        }
        
    }
}
