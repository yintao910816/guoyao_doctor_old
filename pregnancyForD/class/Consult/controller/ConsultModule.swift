//
//  ConsultTableView.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/11/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class ConsultModule: NSObject {    //罗延琼
    
    var replyBlock : ((NSNumber)->())?
    var photoBlock : (( _ info : [String], _ index : NSInteger, _ cell :  BaseChatTableViewCell)->())?
    var pointCvtBlock : ((_ p : CGPoint)->CGPoint)?
    
    var requestDataBlock : (()->())?
    
    var viewModels : [[ConsultViewmodel]]?{
        didSet{
            tableV.reloadData()
        }
    }
    
    var noData : Bool = false {
        didSet{
            if noData == true{
                let f = tableV.frame
                let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: f.width, height: f.height))
                imgV.image = UIImage.init(named: "noData")
                imgV.contentMode = .center
                tableV.addSubview(imgV)
            }
        }
    }
    
    let rejectAndReplyReuse = "rejectAndReplyReuse"
    let supplyReplyReuse = "supplyReplyReuse"

    lazy var tableV : UITableView = {
        let t = UITableView.init()
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    override init() {
        super.init()
        
        let footerV = MJRefreshAutoStateFooter.init(refreshingTarget: self, refreshingAction: #selector(ConsultModule.loadMoreData))
        footerV?.setTitle("", for: .pulling)
        footerV?.setTitle("", for: .willRefresh)
        footerV?.setTitle("", for: .refreshing)
        footerV?.setTitle("", for: .idle)
        footerV?.setTitle("", for: .noMoreData)
        tableV.mj_footer = footerV
        
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        
        tableV.register(ChatTextTableViewCell.self, forCellReuseIdentifier: TypeText)
        tableV.register(ChatPicTableViewCell.self, forCellReuseIdentifier: TypePic)
        tableV.register(ChatVoiceTableViewCell.self, forCellReuseIdentifier: TypeVoice)
        tableV.register(ChatMixTableViewCell.self, forCellReuseIdentifier: TypeMix)
        
        tableV.register(RejectAndReplyView.self, forHeaderFooterViewReuseIdentifier: rejectAndReplyReuse)
        tableV.register(SupplyReplyView.self, forHeaderFooterViewReuseIdentifier: supplyReplyReuse)
    }
    
    @objc func loadMoreData(){
        tableV.mj_footer.endRefreshing()
        requestData()
    }
    
    func requestData(){
        if let block = requestDataBlock{
            block()
        }
    }
}

extension ConsultModule : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = viewModels?[indexPath.section]
        let viewmodel = arr?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: (viewmodel?.model?.type)!, for: indexPath) as! BaseChatTableViewCell
        cell.viewModel = viewmodel
        cell.showPhotoBlock = {[weak self](urlS, i)in
            if let block = self?.photoBlock{
                block(urlS, i, cell)
            }
        }
        cell.convertBlock = {[weak self](p)in
            let p = cell.convert(p, to: tableView)
            if let b = self?.pointCvtBlock {
                return b(p)
            }else{
                return p
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arr = viewModels?[indexPath.section]
        let viewmodel = arr?[indexPath.row]
        return viewmodel!.cellHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let arr = viewModels?[section]
        let status = arr?[0].model?.status
        
        if status == "未回复"{
            return 44
        }else if status == "已回复" || status == "已完结"{
            let dateS = arr![1].model?.replyT
            if Date.isNot24hours(dateS!){
                return 44
            }else{
                return 44
            }
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let arr = viewModels?[section]
        let contId = arr?[0].model?.consultId
        let status = arr?[0].model?.status
        
        if status == "未回复"{
            let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: rejectAndReplyReuse) as! RejectAndReplyView
            v.rejectBlock = {[weak self]()in
                self?.doctorReject(contId: contId!)
            }
            v.replyBlock = {[weak self]()in
                self?.reply(contId: contId!)
            }
            return v
        }else if status == "已回复" || status == "已完结"{
            let dateS = arr![1].model?.replyT
            if Date.isNot24hours(dateS!){
                let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: supplyReplyReuse) as! SupplyReplyView
                v.replyBlock = {[weak self]()in
                    self?.reply(contId: contId!)
                }
                return v
            }else{
                
                let contV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
                contV.backgroundColor = UIColor.white
                
                let divisionV = UIView.init()
                divisionV.backgroundColor = kdivisionColor
                contV.addSubview(divisionV)
                divisionV.snp.updateConstraints { (make) in
                    make.top.equalTo(contV).offset(20)
                    make.left.right.equalTo(contV)
                    make.height.equalTo(1)
                }
                
                let endTime : String = (arr?[0].model?.endTime)!
                HCPrint(message: endTime)
                let timeL = UILabel.init()
                timeL.backgroundColor = UIColor.white
                timeL.textColor = kTextColor
                timeL.font = UIFont.init(name: kReguleFont, size: 13)
                timeL.text = "完结时间：" + endTime
                timeL.textAlignment = .center
                contV.addSubview(timeL)
                timeL.snp.updateConstraints { (make) in
                    make.center.equalTo(contV)
                    make.left.equalTo(contV).offset(80)
                    make.right.equalTo(contV).offset(-80)
                }
                
                let v = UIView()
                v.backgroundColor = kdivisionColor
                contV.addSubview(v)
                v.snp.updateConstraints { (make) in
                    make.bottom.equalTo(contV)
                    make.left.right.equalTo(contV)
                    make.height.equalTo(3)
                }
                
                return contV
            }
        }else{
            let v = UIView()
            v.backgroundColor = kdivisionColor
            return v
        }
    }

    func doctorReject(contId : NSNumber){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_updateConsultStatus(token: (UserManager.shareIntance.currentUser?.token)!, consultId: contId.intValue, doctorId: (UserManager.shareIntance.currentUser?.id?.intValue)!) {[unowned self](isLock) in
            guard isLock == true else {
                SVProgressHUD.dismiss()
                showAlert(title: "提醒", message: "小组成员正在回复中,请稍等...")
                return
            }
            SVProgressHUD.dismiss()
            
            let alertController = UIAlertController(title: "提示信息",
                                                    message: "您确定要拒绝此问题吗？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确认", style: .default, handler: {[unowned self](action)->() in
                HttpRequestManager.shareIntance.doctorReject((UserManager.shareIntance.currentUser?.token)!, consultationId: contId.intValue) { (success, message) in
                    if success == true {
                        HCShowInfo(info: "拒绝成功！")
                        let note = Notification.init(name: NSNotification.Name.init(RejectConsultSuccess), object: nil)
                        NotificationCenter.default.post(note)
                    }else{
                        HCShowError(info: "拒绝失败！")
                    }
                }
            })
            alertController.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func reply(contId : NSNumber){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_updateConsultStatus(token: (UserManager.shareIntance.currentUser?.token)!, consultId: contId.intValue, doctorId: (UserManager.shareIntance.currentUser?.id?.intValue)!) {[weak self](isLock) in
            guard isLock == true else {
                SVProgressHUD.dismiss()
                showAlert(title: "提醒", message: "小组成员正在回复中,请稍等...")
                return
            }
            SVProgressHUD.dismiss()
            
            if let block = self?.replyBlock {
                block(contId)
            }
        }
    }
    
}
