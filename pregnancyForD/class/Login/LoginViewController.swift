//
//  LoginViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    var count = 0
    var timer : Timer?
    
    let KMaxSeconds = 120
    
    let containerV = UIView.init(frame: CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 300))
    
    let aileyunImgV = UIImageView.init(image: UIImage.init(named: "guoyao_logo"))
    
    lazy var gradientL : CAGradientLayer = {
        let l = CAGradientLayer.init()
        l.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100)
        let pingColor = kDefaultThemeColor
        l.colors = [pingColor.cgColor, UIColor.white.cgColor]
        return l
    }()
    
    let cellphoneTF = UITextField()
    let passwordTF = UITextField()
    
    let getCodeBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        observeKeyboard()
        
        self.view.layer.addSublayer(gradientL)
        
        initLoginV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initLoginV(){
        self.view.addSubview(containerV)
        
        aileyunImgV.layer.cornerRadius = 8
        aileyunImgV.clipsToBounds = true
        containerV.addSubview(aileyunImgV)
        aileyunImgV.snp.updateConstraints { (make) in
            make.top.equalTo(containerV)
            make.centerX.equalTo(containerV.snp.centerX)
            make.height.width.equalTo(80)
        }
//        aileyunImgV.contentMode = .scaleAspectFit
        
        let headL = UILabel()
        containerV.addSubview(headL)
        headL.snp.updateConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(aileyunImgV.snp.bottom).offset(40)
        }
        headL.text = "登录名"
        headL.font = UIFont.init(name: kReguleFont, size: 16)
        
        containerV.addSubview(cellphoneTF)
        cellphoneTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(headL)
            make.left.equalTo(headL.snp.right).offset(10)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(20)
        }
        cellphoneTF.placeholder = "输入手机号"
        cellphoneTF.font = UIFont.init(name: kReguleFont, size: 16)
        cellphoneTF.textAlignment = NSTextAlignment.right
        cellphoneTF.keyboardType = UIKeyboardType.numberPad
        cellphoneTF.clearButtonMode = .whileEditing
        cellphoneTF.delegate = self
        cellphoneTF.text = UserDefaults.standard.value(forKey: kCurrentUserPhone) as? String
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(headL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        let passwordL = UILabel()
        containerV.addSubview(passwordL)
        passwordL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(divisionV.snp.bottom).offset(25)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        passwordL.text = "验证码"
        passwordL.font = UIFont.init(name: kReguleFont, size: 16)
        
        containerV.addSubview(passwordTF)
        passwordTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(passwordL)
            make.left.equalTo(passwordL.snp.right).offset(10)
            make.height.equalTo(20)
        }
        passwordTF.font = UIFont.init(name: kReguleFont, size: 16)
        passwordTF.placeholder = "请输入"
        passwordTF.textAlignment = NSTextAlignment.right
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.delegate = self
        
        containerV.addSubview(getCodeBtn)
        getCodeBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(passwordTF)
            make.left.equalTo(passwordTF.snp.right).offset(10)
            make.right.equalTo(containerV).offset(-40)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        getCodeBtn.layer.cornerRadius = 5
        getCodeBtn.setTitle("获取验证码", for: .normal)
        getCodeBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
        getCodeBtn.backgroundColor = kDefaultThemeColor
        
        getCodeBtn.addTarget(self, action: #selector(LoginViewController.startCount), for: .touchUpInside)
        
        let diviV = UIView()
        containerV.addSubview(diviV)
        diviV.snp.updateConstraints { (make) in
            make.top.equalTo(passwordL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        diviV.backgroundColor = kdivisionColor
        
        let loginBtn = UIButton()
        containerV.addSubview(loginBtn)
        loginBtn.snp.updateConstraints { (make) in
            make.top.equalTo(diviV.snp.bottom).offset(50)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(40)
        }
        loginBtn.setTitle("登 录", for: .normal)
        loginBtn.layer.cornerRadius = 10
        loginBtn.backgroundColor = kDefaultThemeColor
        
        loginBtn.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
        
        #if DEBUG
        cellphoneTF.text = "13995631675"
        passwordTF.text  = "8888"
        #endif
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        let rect = CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 400)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 1
        }
    }
    
    @objc func login(){
        
        guard cellphoneTF.text != "" && cellphoneTF.text != nil else {
            HCShowError(info: "请输入手机号码！")
            return
        }
        guard passwordTF.text != "" && passwordTF.text != nil else {
            HCShowError(info: "请输入密码！")
            return
        }
        
        SVProgressHUD.show(withStatus: "登录中...")
        UserManager.shareIntance.loginBySms(cellphoneTF.text!, code: passwordTF.text!) { (success, message) in
            SVProgressHUD.dismiss()
            if success == true{
                SVProgressHUD.showInfo(withStatus: "登录成功！")
                UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
            }else{
                SVProgressHUD.showInfo(withStatus: message)
            }
        }
    }
}



extension LoginViewController {
    func observeKeyboard() -> () {
        //注册键盘出现的通知
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @objc func keyboardShow() -> () {
        let rect = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 400)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 0
        }
    }
}










extension LoginViewController : UITextFieldDelegate {

    //限制输入字符数量
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tempText = textField.text as NSString?
        let tempString = string as NSString
        if let t = tempText {
            let newLength = t.length + tempString.length - range.length
            if cellphoneTF == textField {
                return newLength <= 11
            }else{
                if range.length == 0 {   //增加字符的情况
                    let t = textField.text ?? ""
                    let newS = t + string
                    if newS.lengthOfBytes(using: String.Encoding.utf8) <= 6{
                        textField.text = newS
                    }
                    return false
                }else{
                    return true
                }
            }
        }else{
            return true
        }
        
    }
    
    
    
    
    @objc func startCount(){
//        guard checkIsPhone(self.cellphoneTF.text!) else{
//            HCShowError(info: "请输入正确的手机号码！")
//            return
//        }
        SVProgressHUD.show(withStatus: "获取中...")
        HttpRequestManager.shareIntance.SendSms(self.cellphoneTF.text!) { [weak self](success, message) in
            SVProgressHUD.dismiss()
            if success {
                guard let strongSelf = self else {
                    return
                }
                
                HCShowInfo(info: "获取验证码成功！")
                strongSelf.count = 0
                strongSelf.timer = Timer.scheduledTimer(timeInterval: 1, target: strongSelf, selector: #selector(LoginViewController.showSecond), userInfo: nil, repeats: true)
            }else{
                SVProgressHUD.showError(withStatus: message)
            }
        }
    }
    
    @objc func showSecond()->(){
        
        count = count + 1
        if count == KMaxSeconds {
            resetCodeBtn()
            timer?.invalidate()
        }else{
            let showString = String.init(format: "%ds重新获取", KMaxSeconds - count)
            getCodeBtn.isEnabled = false
            getCodeBtn.setTitle(showString, for: .normal)
            getCodeBtn.backgroundColor = UIColor.gray
        }
    }
    
    
    func resetCodeBtn(){
        
        getCodeBtn.isEnabled = true
        getCodeBtn.setTitle("获取验证码", for: .normal)
        getCodeBtn.backgroundColor = kDefaultThemeColor
    }
    

    func checkIsPhone(_ number : String)->(Bool){
        let regex = "^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:number)
    }
    
}
