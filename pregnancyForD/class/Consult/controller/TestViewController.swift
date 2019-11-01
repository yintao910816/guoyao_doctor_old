//
//  TestViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/11/15.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol GetPhotoCenterDelegate : NSObjectProtocol {
    //设置协议方法
    func getPhotoCenter()->CGPoint
    func getImage()->UIImage
}

extension GetPhotoCenterDelegate {
    func getPhotoCenter()->CGPoint { .zero }
    func getImage()->UIImage { return UIImage() }
}

class TestViewController: UIViewController {
    
    var patientId : NSNumber?     //换取token   获取患者信息   获取咨询信息   罗延琼
    
    var doctorId : NSNumber?      //获取患者信息   获取咨询信息
    
    var doctorS : String?{
        didSet{
            if let s = doctorS{
                if s.contains(","){
                    let arr = s.split(separator: ",")
                    let i = Int(arr[0])
                    doctorId = NSNumber.init(value: i!)
                }else if s != ""{
                    let i = Int(s)
                    doctorId = NSNumber.init(value: i!)
                }
            }
        }
    }

    var identityNo : String?
    
    var hasNext : Bool = true
    
    var pageNo : NSInteger = 1
    
    lazy var webV : UIWebView = {
        let w = UIWebView.init()
        w.delegate = self
        return w
    }()
    
    var url : String? {     //  PATIENT_RECORDS_2017  动态请求
        didSet{
            webviewStartRequest()
        }
    }
    
    weak var photoCenterDelegate : GetPhotoCenterDelegate?
    
    lazy var inputV : InputView = {
        let i = InputView.init()
        i.testVC = self
        return i
    }()
    
    var patientModel : PatientModel?{
        didSet{
            patientM.patientModel = patientModel
        }
    }
    
    var patientM : PatientInfoModule = {
        let p = PatientInfoModule.init()
        return p
    }()
    
    var consultM : ConsultModule = {
        let c = ConsultModule.init()
        return c
    }()
    
    var ReplyModels : [PatientReplyModel]?{
        didSet{
            transferToViewModels(arr: ReplyModels!)
        }
    }
    
    var viewModels : [[ConsultViewmodel]]?{
        didSet{
            consultM.viewModels = viewModels
        }
    }
    
    var tabScrollM : TabScrollModule?
    
    let titleWidth : CGFloat = SCREEN_WIDTH - 40
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "患者咨询"
        self.view.backgroundColor = UIColor.white
        
        setBlock()
        
        //加载进入内存
        DispatchQueue.global().async {
            SharePlayer.shareIntance.audioPlayer.isPlaying
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(TestViewController.requestData), name: NSNotification.Name.init(RejectConsultSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TestViewController.requestData), name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)

        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //展示图片后，清空delegate
        self.navigationController?.delegate = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setBlock(){
        inputV.contentSizeBlock = {[weak self](extraH)in
            let originSize = self?.consultM.tableV.contentSize
            self?.consultM.tableV.contentSize = CGSize.init(width: 0, height: (originSize?.height)! + extraH)
        }
        
        consultM.replyBlock = {[weak self](contId)in
            self?.view.endEditing(true)
            self?.inputV.consultId = contId
            let space = AppDelegate.shareIntance.space
            self?.inputV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 44 - space.topSpace, width: SCREEN_WIDTH, height: 44)
            self?.view.addSubview((self?.inputV)!)
            UIView.animate(withDuration: 0.25, animations: {
                self?.inputV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 88 - space.topSpace - space.bottomSpace, width: SCREEN_WIDTH, height: 44)
            }, completion: { (b) in
                self?.inputV.getReady()
            })
        }
        
        consultM.photoBlock = {[weak self](urlS, i, cell)in
            let showPhotoVC = ShowPhotoViewController()
            showPhotoVC.urlArr = urlS
            showPhotoVC.index = i
            showPhotoVC.indexBlock = cell.indexBlock
            
            self?.photoCenterDelegate = cell
            self?.navigationController?.delegate = self
            self?.navigationController?.pushViewController(showPhotoVC, animated: true)
        }
        
        consultM.pointCvtBlock = {[weak self](p)in
            let tempP = self?.consultM.tableV.convert(p, to: self?.tabScrollM?.scrollV) ?? CGPoint.zero
            let viewP = self?.tabScrollM?.scrollV.convert(tempP, to: self?.view)
            return viewP ?? CGPoint.zero
        }
        
        consultM.requestDataBlock = {[weak self]()in
            self?.requestReplyDetail(isRefresh: false)
        }
    }
    
    func initUI(){
        let contV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        self.view.addSubview(contV)
        
        let x = (SCREEN_WIDTH - titleWidth) / 2
        let titleF = CGRect.init(x: x, y: 5, width: titleWidth, height: 30)
        
        patientM.naviC = self.navigationController
//        patientM.allowEdit = doctorId?.intValue == UserManager.shareIntance.currentUser?.id?.intValue ? true : false
        
        let space = AppDelegate.shareIntance.space
        let scrollF = CGRect.init(x: 0, y: 40, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 84 - space.topSpace - space.bottomSpace)

        tabScrollM = TabScrollModule.init(titles: ["患者病历", "咨询记录", "患者信息"], imgs: ["record", "patMsg", "patInfo"], titleF: titleF, views: [webV, consultM.tableV, patientM.patientTV], scrollF: scrollF) { [weak self](titleV, scrollV) in
            contV.addSubview(titleV)
            self?.view.addSubview(scrollV)
        }

        tabScrollM?.segmentIndex = 1
    }
    
    func initNoDataUI(){
        let contV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        self.view.addSubview(contV)
        
        let x = (SCREEN_WIDTH - titleWidth) / 2
        let titleF = CGRect.init(x: x, y: 5, width: titleWidth, height: 30)
        
        let space = AppDelegate.shareIntance.space
        let scrollF = CGRect.init(x: 0, y: 40, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 84 - space.topSpace - space.bottomSpace)
        
        tabScrollM = TabScrollModule.init(titles: ["患者病历", "咨询记录", "患者信息"], imgs: ["record", "patMsg", "patInfo"], titleF: titleF, views: [webV, getNoDataView(), getNoDataView()], scrollF: scrollF) { [weak self](titleV, scrollV) in
            contV.addSubview(titleV)
            self?.view.addSubview(scrollV)
        }
        
        tabScrollM?.segmentIndex = 1
    }

    func getNoDataView()->UIView{
        let v = UIView.init()
        v.backgroundColor = kDefaultTabBarColor
        let imgV = UIImageView.init(image: UIImage.init(named: "noData"))
        imgV.contentMode = .center
        v.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalTo(v)
        }
        return v
    }
    
    @objc func requestData(){    //张洁
        
        SVProgressHUD.show()
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup.init()
        
        let token = UserManager.shareIntance.currentUser?.token ?? ""
        
        queue.async(group: group, qos: .default, flags: []) {
            //请求患者资料H5地址
            HttpRequestManager.shareIntance.HC_getH5URL(token: token, keyCode: "PATIENT_RECORDS_2017") { [weak self](success, info) in
                if success == true {
                    self?.url = info
                }else{
                    HCShowError(info: info)
                }
            }
        }
        
        if let pId = patientId, let docId = doctorId{
            
            if tabScrollM == nil{
                initUI()
            }
            
            queue.async(group: group, qos: .default, flags: [], execute: {[weak self]()in
                self?.pageNo = 1
                self?.hasNext = true
                self?.requestReplyDetail(isRefresh: true)
            })
            
            queue.async(group: group, qos: .default, flags: [], execute: {
                HttpRequestManager.shareIntance.getPatientInfo((UserManager.shareIntance.currentUser?.token)!, patientId: pId.intValue, doctorId: docId.intValue) { [weak self](success, model, message) in
                    if success == true {
                        self?.patientModel = model
                    }else{
                        HCShowError(info: message)
                    }
                }
            })
        }else{
            initNoDataUI()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                SVProgressHUD.dismiss()
            })
        }
    }
    
    
    func requestReplyDetail(isRefresh : Bool){
        guard hasNext == true else{
            HCShowError(info: "已加载全部信息")
            return
        }
        
        if let pId = patientId{
            var s : String!
            
            if let doctS = doctorS{
                s = doctS
            }else if let doctI = doctorId{
                s = String.init(format: "%@", doctI)
            }
            
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.HC_findPatientReplys((UserManager.shareIntance.currentUser?.token)!, patientId: pId.intValue, doctorIds: s, pageNum: 0, pageSize: 10) { [weak self](success, models, hasNext, message) in
                if success == true {
                    SVProgressHUD.dismiss()
                    self?.pageNo += 1
                    self?.hasNext = hasNext
                    if let arr = models{
                        if isRefresh == true{
                            self?.ReplyModels = arr
                        }else{
                            if let preArr = self?.ReplyModels {
                                let totalArr = preArr + arr
                                self?.ReplyModels = totalArr
                            }else{
                                self?.ReplyModels = arr
                            }
                        }
                    }else{
                        self?.consultM.noData = true
                    }
                }else{
                    HCShowError(info: message)
                    self?.consultM.noData = true
                }
            }
        }
    }
    
    
    func webviewStartRequest(){
        
        guard let u = url else{return}
        
        let token = UserManager.shareIntance.currentUser?.token ?? ""
        let identN = identityNo ?? ""
        
        let s = u + "?token=" + token + "&identityNo=" + identN
        
        HCPrint(message: s)
        
        webV.loadRequest(URLRequest.init(url: URL.init(string: s)!))
    }
    

}

extension TestViewController {
    
    func transferToViewModels(arr : [PatientReplyModel]){
        var readyArr = [[ConsultViewmodel]]()
        for consult in arr {
            var tempArr = [ConsultViewmodel]()
            
            let consultM = ConsultPickModel.init(type: TypeMix, model: consult, replyM : nil)
            let viewM = ConsultViewmodel.init()
            viewM.model = consultM
            tempArr.append(viewM)
            
            if let arr = consult.replyList{
                for i in 0..<arr.count{
                    let model = arr[i] as! ReplyDetailModel
                    
                    //文字
                    if model.replyContent != "" && model.replyContent != nil{
                        let picM = ConsultPickModel.init(type: TypeText, model: consult, replyM : model)
                        let viewM = ConsultViewmodel.init()
                        viewM.model = picM
                        tempArr.append(viewM)
                    }
                    //语音或图片
                    if let imgArr = model.replyImglist{
                        guard imgArr.count > 0 else{continue}
                        let str = imgArr[0] as! String
                        if (str.contains("jpg") || str.contains("png")){
                            let picM = ConsultPickModel.init(type: TypePic, model: consult, replyM : model)
                            let viewM = ConsultViewmodel.init()
                            viewM.model = picM
                            tempArr.append(viewM)
                        }else{
                            let picM = ConsultPickModel.init(type: TypeVoice, model: consult, replyM : model)
                            let viewM = ConsultViewmodel.init()
                            viewM.model = picM
                            tempArr.append(viewM)
                        }
                    }
                }
            }
            readyArr.append(tempArr)
        }
        viewModels = readyArr
    }
}

extension TestViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let pushTransition = PushAnimation()
        
        let p = photoCenterDelegate?.getPhotoCenter() ?? CGPoint.zero
        
        if operation == .push{
            pushTransition.aniType = .kAnimatorTransitionTypePush
            pushTransition.itemCenter = CGPoint.init(x: p.x, y: p.y + 64)
        }else{
            pushTransition.aniType = .kAnimatorTransitionTypePop
            pushTransition.itemCenter = CGPoint.init(x: p.x, y: p.y + 64)
        }
        
        pushTransition.itemSize = CGSize.init(width: PhotoesWidth, height: PhotoesWidth)
        pushTransition.image = photoCenterDelegate?.getImage()
        
        return pushTransition
    }
    
}

extension TestViewController : UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        let s = request.url?.absoluteString
        if s == "app://reload"{
            webView.loadRequest(URLRequest.init(url: URL.init(string: url!)!))
            return false
        }else if (s?.contains("http"))!{
            return true
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        HCPrint(message: "didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        HCPrint(message: "didFinishLoad")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        HCPrint(message: error.localizedDescription)
    }
    
}

