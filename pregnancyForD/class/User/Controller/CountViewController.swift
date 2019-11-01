//
//  CountViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/27.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class CountViewController: UIViewController {
    
//    var changeTextBlock : blankBlock?
    
    lazy var weixinIMV : UIImageView = UIImageView.init(image: UIImage.init(named: "微信"))
    
//    var defaultCountS = ""
//
//    let inputF = NoPasterTextField.init()
//
//    let confirmInputF = NoPasterTextField.init()
    
    let confirmBtn = UIButton.init()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "微信账户管理"
        
        initUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        inputF.text = defaultCountS
//        inputF.becomeFirstResponder()
//    }
    
    func initUI(){
        self.view.backgroundColor = kDefaultTabBarColor
        
        
//        self.view.addSubview(inputF)
//        inputF.snp.updateConstraints { (make) in
//            make.top.equalTo(self.view).offset(35)
//            make.left.right.equalTo(self.view)
//            make.height.equalTo(37)
//        }
//        inputF.placeholder = "输入账号"
//        inputF.backgroundColor = UIColor.white
//        inputF.keyboardType = .numberPad
//
//        var frame0 = inputF.bounds
//        frame0.size.width = 40
//        let phoneIV = UIView.init(frame: frame0)
//        inputF.leftViewMode = UITextFieldViewMode.always
//        inputF.leftView = phoneIV
//
//
//        self.view.addSubview(confirmInputF)
//        confirmInputF.snp.updateConstraints { (make) in
//            make.top.equalTo(inputF.snp.bottom).offset(1)
//            make.left.right.equalTo(self.view)
//            make.height.equalTo(37)
//        }
//        confirmInputF.placeholder = "再次输入"
//        confirmInputF.backgroundColor = UIColor.white
//        confirmInputF.keyboardType = .numberPad
//
//        var frame1 = confirmInputF.bounds
//        frame1.size.width = 40
//        let phoneIV1 = UIView.init(frame: frame0)
//        confirmInputF.leftViewMode = UITextFieldViewMode.always
//        confirmInputF.leftView = phoneIV1
        
        
        self.view.addSubview(weixinIMV)
        weixinIMV.snp.updateConstraints { (make) in
            make.top.equalTo(self.view).offset(40)
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(100)
        }

        
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.updateConstraints { (make) in
            make.top.equalTo(weixinIMV.snp.bottom).offset(60)
            make.centerX.equalTo(self.view)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(40)
        }
        confirmBtn.backgroundColor = kDefaultThemeColor
        
        var btnStr = "绑定"
        let openId = UserManager.shareIntance.currentUser?.openId
        if let id = openId{
            if id.count > 1{
                btnStr = "更换绑定"
            }
        }
        
        confirmBtn.setTitle(btnStr, for: .normal)
        confirmBtn.layer.cornerRadius = 5
        
        confirmBtn.addTarget(self, action: #selector(CountViewController.bindWeixin), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @objc func bindWeixin(){
        
        let req = SendAuthReq.init()
        //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
        req.scope = "snsapi_userinfo"
        //建议第三方带上该参数，可设置为简单的随机数加session进行校验
        req.state = "123"
        if WXApi.isWXAppInstalled(){
            HCPrint(message: "微信已安装")
            WXApi.send(req)
        }else{
            HCPrint(message: "微信未安装")
            WXApi.sendAuthReq(req, viewController: self, delegate: AppDelegate.shareIntance)
        }
        
    }
    
    
    
    
    
    
    func confirmCount(){
        
        
        
//        if inputF.text == "" || inputF.text == nil {
//            HCShowError(info: "请输入账号！")
//            return
//        }else if (inputF.text?.characters.count)! < 12{
//            HCShowError(info: "请输入正确的账号！")
//            return
//        }else if confirmInputF.text == "" || confirmInputF.text == nil{
//            HCShowError(info: "请再次输入账号！")
//            return
//        }
//        if inputF.text != confirmInputF.text {
//            HCShowError(info: "两次输入不一致！")
//            return
//        }
//
//        let numS = inputF.text!
//        updateUserInfo(key: "feecount", value: numS, callback: { (success, message) in
//            if success == true {
//                if let changeTextBlock = self.changeTextBlock {
//                    changeTextBlock()
//                }
//                HCShowInfo(info: "更新成功！")
//            }else{
//                HCShowError(info: "更新失败！")
//            }
//            self.navigationController?.popViewController(animated: true)
//        })

        
    }
}

extension CountViewController {
    
    func updateUserInfo(key : String, value : String, callback : @escaping (_ success : Bool, _ message : String)->()){
        let infoDic = [key : value]
        HttpRequestManager.shareIntance.updateinfo((UserManager.shareIntance.currentUser?.token)!, infoDic: infoDic as NSDictionary) { (success, message) in
            callback(success, message)
        }
    }
    
}
