//
//  PatientInfoView.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/11/17.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class PatientInfoModule: NSObject {
    let reuseIdentifier = "reuseIdentifier"
    
    var naviC : UINavigationController?
    
    var patientCostBlock : ((_ cost : String)->())?
    
    lazy var patientTV : UITableView = {
        let p = UITableView.init()
        p.dataSource = self
        p.delegate = self
        return p
    }()
    
    var patientModel : PatientModel? {
        didSet{
            setDate()
            patientTV.reloadData()
        }
    }
    
    lazy var headV : UIView = {
        let h = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 180))
        return h
    }()
    
    lazy var headIV : UIImageView = {
        let h = UIImageView.init()
        return h
    }()
    
    lazy var nameL : UILabel = {
        let n = UILabel.init()
        return n
    }()
    
    lazy var sexIV : UIImageView = {
        let s = UIImageView.init()
        return s
    }()
    
    var allowEdit : Bool = true
    
    override init() {
        super.init()
        setHeaderView()
        
        patientTV.register(PatientDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        patientTV.register(UINib.init(nibName: "PatientDetailTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    convenience init(patientF : CGRect){
        self.init()
        
        patientTV.frame = patientF
    }
    
    func setHeaderView(){
        headV.addSubview(headIV)
        headIV.snp.updateConstraints({ (make) in
            make.top.equalTo(headV).offset(20)
            make.width.height.equalTo(100)
            make.centerX.equalTo(headV)
        })
        headIV.layer.cornerRadius = 50
        headIV.clipsToBounds = true
        headIV.contentMode = UIViewContentMode.scaleAspectFill
        
        headV.addSubview(nameL)
        nameL.snp.updateConstraints({ (make) in
            make.top.equalTo(headIV.snp.bottom).offset(16)
            make.centerX.equalTo(headV).offset(-10)
        })
        nameL.font = UIFont.systemFont(ofSize: 17)
        
        headV.addSubview(sexIV)
        sexIV.snp.updateConstraints({ (make) in
            make.centerY.equalTo(nameL)
            make.left.equalTo(nameL.snp.right).offset(10)
        })
        sexIV.contentMode = UIViewContentMode.left
        
        patientTV.tableHeaderView = headV
    }
    
    func setDate(){
        if let s = patientModel?.headImg{
            headIV.HC_setImageFromURL(urlS: s, placeHolder: "HC-touxiang1")
        }else{
            headIV.image = UIImage.init(named: "HC-touxiang1")
        }
        
        nameL.text = patientModel?.patientNickName
        nameL.sizeToFit()
        
        if patientModel?.patientGender?.intValue == 0 {
            sexIV.image = UIImage.init(named: "HC-nan")
        }else{
            sexIV.image = UIImage.init(named: "HC-nv")
        }
    }
}

extension PatientInfoModule : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if patientModel != nil{
            return 5
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PatientDetailTableViewCell
        
        if row == 0 {
            cell.patientDetailTitle.text = "姓名"
            if let name = patientModel?.patientRealName{
                cell.patientDetailContent.text = name
            }else{
                if let nickName = patientModel?.patientNickName{
                    cell.patientDetailContent.text = nickName
                }else{
                    cell.patientDetailContent.text = "匿名"
                }
            }
        }else if row == 1 {
            cell.patientDetailTitle.text = "年龄"
            if let age = patientModel?.patientAge {
                    cell.patientDetailContent.text = String.init(format: "%d 岁", age.intValue)
            }else{
                cell.patientDetailContent.text = "未填写"
            }
        }else if row == 2 {
            cell.patientDetailTitle.text = "分组"
            cell.patientDetailContent.layer.borderWidth = 1
            cell.patientDetailContent.layer.borderColor = kDefaultBlueColor.cgColor
            cell.patientDetailContent.layer.cornerRadius = 5
            cell.patientDetailContent.clipsToBounds = true
            cell.patientYou.isHidden = false
            cell.patientDetailContent.textAlignment = NSTextAlignment.center
            
            if let tagName = patientModel?.tagName{
                cell.patientDetailContent.text = tagName
                cell.patientDetailContent.sizeToFit()
                var tempF = cell.patientDetailContent.frame
                let width = tempF.size.width + 6
                let height = tempF.size.height + 6
                cell.patientDetailContent.snp.updateConstraints { (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }else{
                cell.patientDetailContent.text = "默认分组"
                cell.patientDetailContent.sizeToFit()
                var tempF = cell.patientDetailContent.frame
                let width = tempF.size.width + 6
                let height = tempF.size.height + 6
                cell.patientDetailContent.snp.updateConstraints { (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
        }else if row == 3 {
            cell.patientDetailTitle.text = "资费标准"
            if let charge = patientModel?.charged{
                if charge == "0"{
                    cell.patientDetailContent.text = "免费"
                }else{
                    cell.patientDetailContent.text = (charge as String) + "元/次"
                }
            }
            cell.patientYou.isHidden = false
        }else if row == 4 {
            cell.patientDetailTitle.text = "屏蔽该患者"
            if let refused = patientModel?.refused {
                if refused == "0" {
                    cell.HCswitch.setOn(false, animated: false)
                }else{
                    cell.HCswitch.setOn(true, animated: false)
                }
            }
            cell.patientDetailContent.isHidden = true
            cell.HCswitch.isHidden = false
            cell.allowEdit = allowEdit
            cell.shieldBlock = {[unowned self](s)in
                let scanner = Scanner(string: s)
                var num : Int = 0
                scanner.scanInt(&num)
                HttpRequestManager.shareIntance.updatePatientInfo((UserManager.shareIntance.currentUser?.token)!, patientId: (self.patientModel?.p_id?.intValue)!, type: 2, value: CGFloat(num), callback: {(success, message) in
                    if success == true {
                        HCShowInfo(info: "修改成功！")
                    }else{
                        HCShowError(info: "修改失败！")
                        let mainQueue = DispatchQueue.main
                        mainQueue.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                            let tempS = s == "0" ? "1" : "0"
                            cell.changeSwitch(isOn: tempS)
                        })
                    }
                })
            }
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            guard allowEdit == true else{return}
            let groupSelectVC = GroupManagerController()
            groupSelectVC.forSelector = true
            groupSelectVC.patienId = patientModel?.p_id
            groupSelectVC.groupS = patientModel?.tagName
            groupSelectVC.changeGroup = {[weak self](groupName) in
                let cell = self?.patientTV.cellForRow(at: indexPath) as! PatientDetailTableViewCell
                cell.patientDetailContent.text = groupName
                cell.patientDetailContent.sizeToFit()
                let tempF = cell.patientDetailContent.frame
                let width = tempF.size.width + 6
                let height = tempF.size.height + 6
                cell.patientDetailContent.snp.updateConstraints { (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
            naviC?.pushViewController(groupSelectVC, animated: true)
            
        }else if indexPath.row == 3 {
            guard allowEdit == true else{return}
            let expensesVC = ExpensesViewController()
            expensesVC.patientModel = patientModel
            expensesVC.textChangeBlock = {[weak self](new)in
                let cell = self?.patientTV.cellForRow(at: indexPath) as! PatientDetailTableViewCell
                if new == "0"{
                    cell.patientDetailContent.text = "免费"
                }else{
                    cell.patientDetailContent.text = new + "元/次"
                }
                if let block = self?.patientCostBlock{
                    block(new)
                }
            }
            naviC?.pushViewController(expensesVC, animated: true)
        }
        
        //            let webVC = WebViewController()
        //            webVC.url = "http://wechat.ivfcn.com/MpWechat/hollybeacon/weixin/information/home.jsp?"
        //            webVC.title = "病历信息"
        //            self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
}
