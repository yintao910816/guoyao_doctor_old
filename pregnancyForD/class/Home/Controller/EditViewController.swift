//
//  EditViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/1.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var limitNumberOfWords : NSInteger?
    var infoString : String? {
        didSet{
            inputTextView.text = infoString
            self.textViewDidChange(inputTextView)
        }
    }
    var changeTextBlock : changeBlock?
    
    var isFeedback : Bool?
    var isEditIntro : Bool?
    
    var isEditGoodat : Bool?
//    var isEditCount : Bool?
    
    var isEditGroup : Bool?
    var tagid : NSInteger?
    
    var isAddTemplate : Bool?
    
    var isAddGroup : Bool?
    
    let confirmBtn = UIButton()
    let cancelBtn = UIButton()
    let inputTextView = UITextView()
    let placeHolderL = UILabel()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        if isFeedback == true {
            self.navigationItem.title = "意见反馈"
        }else{
            self.navigationItem.title = "编辑文字"
        }
        
        initUI()
    }
    
    func initUI(){
        
        self.view.addSubview(inputTextView)
        inputTextView.snp.updateConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(130)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(16)
        }
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = kDefaultThemeColor.cgColor
        inputTextView.font = UIFont.systemFont(ofSize: 20)
        inputTextView.layer.cornerRadius = 5
        inputTextView.delegate = self
//        if isEditCount == true {
//            inputTextView.keyboardType = UIKeyboardType.numberPad
//        }
        
        inputTextView.addSubview(placeHolderL)
        placeHolderL.snp.updateConstraints { (make) in
            make.left.top.equalTo(inputTextView).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        placeHolderL.font = UIFont.systemFont(ofSize: 20)
        placeHolderL.text = "请输入"
        placeHolderL.textColor = UIColor.lightGray
        placeHolderL.sizeToFit()
        
        self.view.addSubview(cancelBtn)
        cancelBtn.snp.updateConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(inputTextView.snp.bottom).offset(16)
            make.left.equalTo(inputTextView)
        }
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.backgroundColor = kDefaultThemeColor
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.addTarget(self, action: #selector(EditViewController.cancelAction), for: .touchUpInside)
        
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.updateConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(inputTextView.snp.bottom).offset(16)
            make.right.equalTo(inputTextView)
        }
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.backgroundColor = kDefaultThemeColor
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.addTarget(self, action: #selector(EditViewController.confirmAction), for: .touchUpInside)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension  EditViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderL.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" || textView.text == nil {
            placeHolderL.isHidden = false
        }else{
            placeHolderL.isHidden = true
        }
    }
}

extension EditViewController {
    @objc func cancelAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmAction(){
        if inputTextView.text != "" {
            
            if isFeedback == true{
                HCShowInfo(info: "反馈成功！")
                self.navigationController?.popViewController(animated: true)
            }
            
            if isEditGroup == true{
                HttpRequestManager.shareIntance.tagsOperation((UserManager.shareIntance.currentUser?.token)!, tagId: tagid!, tagname: inputTextView.text, opsType: 1, callback: { (success, array, message) in
                    if success == true{
                        HCShowInfo(info: "修改成功！")
                        let note = Notification.init(name: NSNotification.Name.init(AddGroupSuccess), object: nil)
                        NotificationCenter.default.post(note)
                    }else{
                        HCShowError(info: "修改失败！")
                    }
                })
                
                self.navigationController?.popViewController(animated: true)
            }
            
            if isAddTemplate == true{
                
                HttpRequestManager.shareIntance.consultTemplate((UserManager.shareIntance.currentUser?.token)!, templateValue: 0, templateContent: inputTextView.text, opsType: 3) { [unowned self](success, array, message) in
                    //                    操作类型（0-查询；1-修改；2-删除；3-添加）
                    if success == true {
                        HCShowInfo(info: "添加成功！")
                        if let changeTextBlock = self.changeTextBlock {
                            changeTextBlock("")
                        }
                    }else{
                        HCShowError(info: "添加失败！")
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            if isEditIntro == true {
                updateUserInfo(key: "brife", value: inputTextView.text, callback: { (success, message) in
                    if success == true {
                        let note = Notification.init(name: NSNotification.Name.init(ModifyDoctorIntro), object: nil)
                        NotificationCenter.default.post(note)
                        HCShowInfo(info: "更新成功！")
                    }else{
                        HCShowError(info: "更新失败！")
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
            if isAddGroup == true {
                addTagGroup(groupName: inputTextView.text, callback: { [unowned self](success, message) in
                    if success == true{
                        HCShowInfo(info: "添加成功！")
                        let note = Notification.init(name: NSNotification.Name.init(AddGroupSuccess), object: nil)
                        NotificationCenter.default.post(note)
                    }else{
                        HCShowError(info: "添加失败！")
                    }
                })
                self.navigationController?.popViewController(animated: true)
            }
            
            if isEditGoodat == true {
                if inputTextView.text.count > 10{
                    HCShowError(info: "十个字符之内！")
                }else{
                    updateUserInfo(key: "goodproject", value: inputTextView.text, callback: { (success, message) in
                        if success == true {
                            if let changeTextBlock = self.changeTextBlock {
                                changeTextBlock(self.inputTextView.text)
                            }
                            HCShowInfo(info: "更新成功！")
                        }else{
                            HCShowError(info: "更新失败！")
                        }
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
//            if isEditCount == true {
//                let numS = inputTextView.text!
//                updateUserInfo(key: "feecount", value: numS, callback: { (success, message) in
//                    if success == true {
//                        if let changeTextBlock = self.changeTextBlock {
//                            changeTextBlock("")
//                        }
//                        HCShowInfo(info: "更新成功！")
//                    }else{
//                        HCShowError(info: "更新失败！")
//                    }
//                    self.navigationController?.popViewController(animated: true)
//                })
//            }
        }else{
            //提示
            HCShowError(info: "请输入文字！")
        }
    }
}

extension EditViewController {
    func addTagGroup(groupName : String, callback : @escaping (_ success : Bool, _ message : String)->()){
        HttpRequestManager.shareIntance.tagsOperation((UserManager.shareIntance.currentUser?.token)!, tagId: 0, tagname: groupName, opsType: 3) { (success, array, message) in
            callback(success, message)
        }
    }
    
    
    
    func updateUserInfo(key : String, value : String, callback : @escaping (_ success : Bool, _ message : String)->()){
        let infoDic = [key : value]
        HttpRequestManager.shareIntance.updateinfo((UserManager.shareIntance.currentUser?.token)!, infoDic: infoDic as NSDictionary) { (success, message) in
            callback(success, message)
        }
    }
   
}
