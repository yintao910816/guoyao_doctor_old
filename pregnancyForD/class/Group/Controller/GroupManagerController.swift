//
//  GroupManagerController.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/12.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD

class GroupManagerController: UIViewController {
    
    let ReuseIdentifier = "ReuseIdentifier"
    
    let inputF = UITextField()
    let editBtn = UIButton()
    
    var collectionV : UICollectionView?
    
    var selectedRow : NSInteger?{
        didSet{
            inputF.text = tempArr[selectedRow!]
            inputF.becomeFirstResponder()
        }
    }
    
    var tempArr = [String]()
    var groupArray : [TagGroupModel]? {
        didSet{
            tempArr.append("默认分组")
            for i in groupArray! {
                tempArr.append(i.tagName!)
            }
            collectionV?.reloadData()
        }
    }
    var patienId : NSNumber?
    var groupS : String?
    var forSelector = false
    var changeGroup : changeBlock?
    
    var widthDic = [NSInteger : CGFloat]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if forSelector == true {
            self.navigationItem.title = "选择分组"
        }else{
            self.navigationItem.title = "分组管理"
        }
        
        self.view.backgroundColor = kDefaultTabBarColor
        
        initUI()
        
        requestData()
    }
    

    func initUI(){
        
        self.view.addSubview(inputF)
        inputF.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(KDefaultPadding)
            make.top.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-KDefaultPadding)
            make.height.equalTo(44)
        }
        inputF.placeholder = "请输入"
        inputF.layer.borderWidth = 1
        inputF.layer.borderColor = kdivisionColor.cgColor
        inputF.layer.cornerRadius = 5
        inputF.backgroundColor = UIColor.white
        inputF.font = UIFont.systemFont(ofSize: 17)
        
        //  左内边距
        var frame = inputF.frame
        frame.size.width = 10
        let leftV = UIView.init(frame: CGRect.init(origin: CGPoint.init(), size: frame.size))
        inputF.leftViewMode = .always
        inputF.leftView = leftV
        
        self.view.addSubview(editBtn)
        editBtn.snp.updateConstraints { (make) in
            make.right.bottom.equalTo(inputF).offset(-5)
            make.top.equalTo(inputF).offset(5)
            make.width.equalTo(80)
        }
        editBtn.setTitle("添加分组", for: .normal)
        editBtn.setTitle("修改分组", for: .selected)
        editBtn.layer.cornerRadius = 5
        editBtn.titleLabel?.textColor = UIColor.white
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        editBtn.backgroundColor = kDefaultThemeColor
        editBtn.addTarget(self, action: #selector(GroupManagerController.textConfirmAction), for: .touchUpInside)
        
        let infoL = UILabel()
        self.view.addSubview(infoL)
        
        infoL.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(KDefaultPadding)
            make.top.equalTo(inputF.snp.bottom).offset(14)
            make.width.equalTo(150)
            make.height.equalTo(15)
        }

        infoL.text = "选择已有分组"
        infoL.font = UIFont.systemFont(ofSize: 17)
        
        if forSelector == false {
            let reminderL = UILabel()
            self.view.addSubview(reminderL)
            reminderL.snp.updateConstraints { (make) in
                make.right.equalTo(self.view).offset(-KDefaultPadding)
                make.centerY.equalTo(infoL)
                make.width.equalTo(150)
                make.height.equalTo(15)
            }
            reminderL.text = "长按标签删除"
            reminderL.textAlignment = NSTextAlignment.right
            reminderL.textColor = kDefaultBlueColor
            reminderL.font = UIFont.systemFont(ofSize: 17)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CGFloat(KDefaultPadding)
        collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100), collectionViewLayout: layout)
        self.view.addSubview(collectionV!)
        collectionV?.snp.updateConstraints { (make) in
            make.top.equalTo(infoL.snp.bottom).offset(14)
            make.right.equalTo(self.view).offset(-KDefaultPadding)
            make.left.equalTo(self.view).offset(KDefaultPadding)
            make.bottom.equalTo(self.view)
        }
        collectionV?.backgroundColor = UIColor.white
        collectionV?.dataSource = self
        collectionV?.delegate = self
        collectionV?.register(GroupManagerViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
        collectionV?.backgroundColor = kDefaultTabBarColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GroupManagerController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier, for: indexPath) as! GroupManagerViewCell
        cell.contentS = tempArr[indexPath.row]
        cell.chooseBlock = {[unowned self](content)in
            if self.forSelector == false {
                self.selectedRow = indexPath.row
                self.editBtn.isSelected = true
            }else{
                if indexPath.row == 0 {
                    if self.groupS != nil{
                        // 默认分组没有对应的编号
                        self.modifyGroup(0, groupS: content, callback: { [unowned self](success, message) in
                            if success == true {
                                if let changeGroup = self.changeGroup {
                                    changeGroup(self.tempArr[indexPath.row])
                                }
                                HCShowInfo(info: "修改成功！")
                            }else{
                                HCShowError(info: "修改失败！")
                            }
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        HCShowInfo(info: "已经是默认分组！")
                    }
                }else{
                    let data = self.groupArray?[indexPath.row - 1]
                    
                    if let groupS = self.groupS {
                        if data?.tagName == groupS{
                            HCShowInfo(info: "相同分组！")
                            return
                        }
                    }
                    self.modifyGroup((data?.id?.intValue)!, groupS: content, callback: { [unowned self](success, message) in
                        if success == true {
                            if let changeGroup = self.changeGroup {
                                changeGroup(self.tempArr[indexPath.row])
                            }
                            HCShowInfo(info: "修改成功！")
                        }else{
                            HCShowError(info: "修改失败！")
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        cell.longPressBlock = {[unowned self](content)in
            self.inputF.text = ""
            self.inputF.resignFirstResponder()
            self.editBtn.isSelected = false
            
            if self.forSelector == true {return}
            
            if indexPath.row  < 3 {
                HCShowError(info: "系统自带分组！")
                return
            }
            
            let alertController = UIAlertController(title: "提示信息",
                                                    message: "您确定要删除吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {[unowned self](action)->() in
                let data = self.groupArray?[indexPath.row - 1]
                //            操作类型（0-查询；1-修改；2-删除；3-添加）
                HttpRequestManager.shareIntance.tagsOperation((UserManager.shareIntance.currentUser?.token)!, tagId: (data?.id?.intValue)!, tagname: (data?.tagName)!, opsType: 2, callback: { [unowned self](success, array, message) in
                    if success == true{
                        self.requestData()
                        
                        let not = Notification.init(name: NSNotification.Name.init(RemoveGroupSuccess), object: nil, userInfo: nil)
                        NotificationCenter.default.post(not)
                    }else{
                        HCShowError(info: "删除失败！")
                    }
                })
                
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if widthDic[indexPath.row] == nil{
            let tempCell = GroupManagerViewCell()
            tempCell.contentS = tempArr[indexPath.row]
            let width = tempCell.finalWidth
            widthDic[indexPath.row] = width
            return CGSize.init(width: width!, height: 40)
        }else{
            return CGSize.init(width: widthDic[indexPath.row]!, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

extension GroupManagerController {
    
    func requestData(){
        SVProgressHUD.show()
        tempArr = [String]()
        widthDic = [NSInteger : CGFloat]()
        HttpRequestManager.shareIntance.tagsOperation((UserManager.shareIntance.currentUser?.token)!, tagId: 0, tagname: "", opsType: 0) { [unowned self](success, array, message) in
            if success == true{
                SVProgressHUD.dismiss()
                self.groupArray = array
            }else{
                HCShowError(info: message)
            }
        }
    }


    func modifyGroup(_ value : NSInteger, groupS : String, callback : @escaping (_ success : Bool, _ message : String)->()){
        
        if patienId != nil {
            HttpRequestManager.shareIntance.updatePatientInfo((UserManager.shareIntance.currentUser?.token)!, patientId: (patienId?.intValue)!, type: 0, value: value) { [unowned self](success, message) in
                callback(success, message)
                if success == true {
                    let not = Notification.init(name: NSNotification.Name.init(UpdatePatientInfo), object: nil, userInfo: nil)
                    NotificationCenter.default.post(not)
                }
            }
        }
    }

    @objc func textConfirmAction(){
        
        if editBtn.isSelected == false {
            // 添加分组
            if inputF.text != nil && inputF.text != "" {
                let str = inputF.text!
                if str.count > 10 {
                    HCShowError(info: "字符不可超过十个！")
                }else{
                    HttpRequestManager.shareIntance.tagsOperation((UserManager.shareIntance.currentUser?.token)!, tagId: 0, tagname: inputF.text!, opsType: 3) { [unowned self](success, array, message) in
                        if success == true {
                            self.inputF.text = ""
                            self.inputF.resignFirstResponder()
                            let note = Notification.init(name: NSNotification.Name.init(AddGroupSuccess), object: nil)
                            NotificationCenter.default.post(note)
                            self.requestData()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                                HCShowInfo(info: "添加成功，请选择相应分组！")
                            })
                        }else{
                            HCPrint(message: "添加失败！")
                        }
                    }
                }
            }else{
                HCShowError(info: "请输入文字！")
            }
        }else{
            // 修改分组
            if selectedRow! < 3 {
                HCShowError(info: "系统自带分组！")
                return
            }else{
                if inputF.text != "" && inputF.text != nil{
                    let str = inputF.text!
                    if str.count > 10 {
                        HCShowError(info: "字符不可超过十个！")
                    }else{
                        HttpRequestManager.shareIntance.tagsOperation((UserManager.shareIntance.currentUser?.token)!, tagId: (groupArray![selectedRow! - 1].id?.intValue)!, tagname: inputF.text!, opsType: 1, callback: { [unowned self](success, array, message) in
                            if success == true{
                                self.editBtn.isSelected = false
                                self.inputF.text = ""
                                self.inputF.resignFirstResponder()
                                let note = Notification.init(name: NSNotification.Name.init(AddGroupSuccess), object: nil)
                                NotificationCenter.default.post(note)
                                self.requestData()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                                    HCShowInfo(info: "修改成功！")
                                })
                            }else{
                                HCShowError(info: "修改失败！")
                            }
                        })
                    }
                }else{
                    HCShowError(info: "文字为空！")
                }
            }
        }
    }
}
