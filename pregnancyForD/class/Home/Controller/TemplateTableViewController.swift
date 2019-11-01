//
//  GroupManagerTableViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/11.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class TemplateTableViewController: BaseTableViewController {
    
//    weak var inputVC : InputViewController?
    
    var setTextBlock : changeBlock?
    
    lazy var GroupHeaderView : UIView = {
        let containerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        let plusBtn = UIButton.init(frame: CGRect.init(x: 16, y: 10, width: 30, height: 30))
        plusBtn.setBackgroundImage(UIImage.init(named: "HC-jiahao"), for: .normal)
        plusBtn.contentMode = .center
        containerV.addSubview(plusBtn)
        
        let addL = UILabel.init(frame: CGRect.init(x: 50, y: 10, width: 100, height: 30))
        containerV.addSubview(addL)
        addL.text = "添加"
        addL.font = UIFont.systemFont(ofSize: 22)
        addL.textColor = kDefaultThemeColor
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(TemplateTableViewController.addAction))
        containerV.addGestureRecognizer(tapG)
        
        let divisionV = UIView.init(frame: CGRect.init(x: 0, y: 50, width: SCREEN_WIDTH, height: 1))
        containerV.addSubview(divisionV)
        divisionV.backgroundColor = kdivisionColor
        
        return containerV
    }()
    
    var tableViewArray = [TemplateModel]()
    
    let reuseIdentifier = "reuseIdentifier"
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "快捷回复"
        requestData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.tableHeaderView = GroupHeaderView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        cell.textLabel?.text = tableViewArray[indexPath.row].templateContent!
        cell.textLabel?.font = UIFont.systemFont(ofSize: 21)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        let t = tableViewArray[indexPath.row].templateContent!
        
        if let setTextBlock = setTextBlock{
            setTextBlock(t)
        }
    }
    
    //返回编辑类型，滑动删除
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //在这里修改删除按钮的文字
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "点击删除"
    }
    
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if indexPath.row < 2 {
                HCShowError(info: "系统自带分组！")
                self.tableView.reloadData()
                return
            }
            
            HttpRequestManager.shareIntance.consultTemplate((UserManager.shareIntance.currentUser?.token)!, templateValue: (tableViewArray[indexPath.row].id?.intValue)!, templateContent: "", opsType: 2) { [unowned self](success, array, message) in
                //                    操作类型（0-查询；1-修改；2-删除；3-添加）
                if success == true {
                    self.requestData()
                }else{
                    HCShowError(info: "删除失败！")
                }
            }
        }
    }
}

extension TemplateTableViewController {
    
    @objc func addAction(){
        let editVC = EditViewController()
        editVC.isAddTemplate = true
        editVC.changeTextBlock = {[unowned self](new) in
            self.requestData()
        }
        self.navigationController?.pushViewController(editVC, animated: true)
    }

    func requestData(){
        HttpRequestManager.shareIntance.consultTemplate((UserManager.shareIntance.currentUser?.token)!, templateValue: 0, templateContent: "", opsType: 0) { [unowned self](success, array, message) in
            if success == true {
                self.tableViewArray = array!
                self.tableView.reloadData()
            }else{
                HCShowError(info: "请求数据失败！")
            }
        }
    }

    
    
}
