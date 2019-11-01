//
//  InputView.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/10/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SVProgressHUD

class InputView: UIView {
//    weak var contVC : ConsultViewController?
    
    weak var testVC : TestViewController?
    
    let padding : CGFloat = 2
    let btnW : CGFloat = 40
    
    var contentSizeBlock : ((_ height : CGFloat)->())?
    var extraH : CGFloat = 0

    lazy var switchBtn : UIButton = {
        let s = UIButton.init()
        s.setImage(UIImage.init(named: "HC-yuyin"), for: .normal)
        s.setImage(UIImage.init(named: "HC-jianpan"), for: .selected)
        return s
    }()
    
    lazy var inputTextView : UITextView = {
        let i = UITextView.init()
        i.layer.borderWidth = 1
        i.layer.borderColor = kdivisionColor.cgColor
        i.layer.cornerRadius = 5
        i.font = UIFont.init(name: kReguleFont, size: 15)
        i.returnKeyType = .send
        i.delegate = self
        return i
    }()
    
    lazy var speakBtn : UIButton = {
        let s = UIButton.init()
        s.isHidden = true
        s.setTitle("按住说话", for: .normal)
        s.setTitleColor(UIColor.darkText, for: .normal)
        s.layer.borderWidth = 1
        s.layer.borderColor = kdivisionColor.cgColor
        s.layer.cornerRadius = 5
        return s
    }()
    
    lazy var photoChooseBtn : UIButton = {
        let p = UIButton.init()
        p.setImage(UIImage.init(named: "HC-zhaopian"), for: .normal)
        p.setImage(UIImage.init(named: "HC-zhaopian-selector"), for: .selected)
        return p
    }()
    
    lazy var templateBtn : UIButton = {
        let t = UIButton.init()
        t.setImage(UIImage.init(named: "HC-kuaijiehuifu"), for: .normal)
        return t
    }()
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
        
    var photoIsShow : Bool = false
    
    var draftS : String = ""
    
    var doctorId : String?
    
    var consultId : NSNumber? {
        didSet{
            let tempS = UserDefaults.standard.value(forKey: String.init(format: "%d", (consultId?.intValue)!)) as? String
            if tempS != nil && tempS != "" {
                draftS = tempS!
                inputTextView.text = draftS
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { [weak self]()in
                    self?.textViewDidChange((self?.inputTextView)!)
                })
            }
            
            if oldValue != consultId {
                guard oldValue != nil else {return}
                let key = String.init(format: "%d", (oldValue?.intValue)!)
                UserDefaults.standard.set(draftS, forKey: key)
            }
        }
    }
    
    var currentAudioPath : String = ""
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(8000.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatLinearPCM)),//编码格式
        AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//音频质量
    
    lazy var voiceRecordingV : VoiceRecordingView = {
        let v = VoiceRecordingView()
        return v
    }()
    
    lazy var photoPickV : PhotoPickerView = {
        let p = PhotoPickerView.init()
        p.sendSuccessBlock = {[weak self]()in
            self?.removeFromSuperview()
        }
        return p
    }()
        
        
    lazy var voiceConfirmView : ConfirmVoiceView = {
        let confirV = ConfirmVoiceView.init()
        confirV.playBlock = {[weak self]()in
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            } catch {
            }
            
            if let audioPlayer = self?.audioPlayer{
                if audioPlayer.isPlaying {
                    audioPlayer.stop()
                }else{
                    audioPlayer.play()
                }
            }
        }
        confirV.sendBlock = {[weak self]()in
            if let audioPlayer = self?.audioPlayer {
                if audioPlayer.isPlaying {
                    audioPlayer.stop()
                }
            }
            self?.audioPlayer = nil
            self?.audioRecorder = nil
            // 发送语音
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.uploadVoice((UserManager.shareIntance.currentUser?.token)!, doctorId: (self?.doctorId!)!, voiceFile: (self?.amrPath())!, type: "3", consultationId: (self?.consultId?.intValue)!) {(success, message) in
                if success == true {
                    HCShowInfo(info: "语音发送成功！")
                    self?.removeFromSuperview()
                    let note = Notification.init(name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
                    NotificationCenter.default.post(note)
                }else{
                    HCShowError(info: "语音发送失败！")
                }
            }
            UIView.animate(withDuration: 0.25, animations: { [weak self]() in
                self?.voiceConfirmView.frame = CGRect.init(x: 0, y: 44, width: SCREEN_WIDTH, height: 44)
                }, completion: { (b) in
                    self?.voiceConfirmView.removeFromSuperview()
            })
        }
        confirV.deleteBlock = {[weak self]()in
            if let audioPlayer = self?.audioPlayer {
                if audioPlayer.isPlaying {
                    audioPlayer.stop()
                }
            }
            UIView.animate(withDuration: 0.25, animations: {
                self?.voiceConfirmView.frame = CGRect.init(x: 0, y: 44, width: SCREEN_WIDTH, height: 44)
                }, completion: {(b)in
                    self?.voiceConfirmView.removeFromSuperview()
            })
        }
        return confirV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        doctorId = String.init(format: "%d", (UserManager.shareIntance.currentUser?.id?.intValue)!)
        
        self.addSubview(switchBtn)
        switchBtn.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(padding)
            make.bottom.equalTo(self).offset(-padding)
            make.width.equalTo(btnW)
            make.height.equalTo(40)
        }
        self.addSubview(templateBtn)
        templateBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-padding)
            make.bottom.equalTo(self).offset(-padding)
            make.width.equalTo(btnW)
            make.height.equalTo(40)
        }
        self.addSubview(photoChooseBtn)
        photoChooseBtn.snp.updateConstraints { (make) in
            make.right.equalTo(templateBtn.snp.left).offset(-padding)
            make.bottom.equalTo(self).offset(-padding)
            make.width.equalTo(btnW)
            make.height.equalTo(40)
        }
        self.addSubview(inputTextView)
        inputTextView.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(padding)
            make.left.equalTo(switchBtn.snp.right).offset(padding)
            make.right.equalTo(photoChooseBtn.snp.left).offset(-padding)
            make.bottom.equalTo(self).offset(-padding)
        }
        self.addSubview(speakBtn)
        speakBtn.snp.updateConstraints { (make) in
            make.left.equalTo(switchBtn.snp.right).offset(padding)
            make.bottom.equalTo(self).offset(-padding)
            make.right.equalTo(photoChooseBtn.snp.left).offset(-padding)
            make.height.equalTo(40)
        }
        
        addTargetForBtn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(InputView.keboardWillShow(anotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InputView.keboardWillDismiss(anotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getReady(){
        photoIsShow = false
        photoChooseBtn.isSelected = false
        speakBtn.isHidden = true
        switchBtn.isSelected = false
        
        voiceConfirmView.removeFromSuperview()
        
        inputTextView.becomeFirstResponder()
    }
    
    func addTargetForBtn(){
        switchBtn.addTarget(self, action: #selector(InputView.switchToVoice(btn:)), for: .touchUpInside)
        
        speakBtn.addTarget(self, action: #selector(InputView.speakBtnTouchDown(btn:)), for: .touchDown)
        speakBtn.addTarget(self, action: #selector(InputView.speakBtnTouchUpInside(btn:)), for: .touchUpInside)
        speakBtn.addTarget(self, action: #selector(InputView.speakBtnDragInside(btn:)), for: .touchDragInside)
        speakBtn.addTarget(self, action: #selector(InputView.speakBtnDragOutside(btn:)), for: .touchDragOutside)
        speakBtn.addTarget(self, action: #selector(InputView.speakBtnTouchUpOutside(btn:)), for: .touchUpOutside)
        
        photoChooseBtn.addTarget(self, action: #selector(InputView.photoPickerBtn(btn:)), for: .touchUpInside)
        templateBtn.addTarget(self, action: #selector(InputView.templateBtn(btn:)), for:.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        if let id = consultId {
            let key = String.init(format: "%d", id.intValue)
            UserDefaults.standard.set(draftS, forKey: key)
        }
        
        NotificationCenter.default.removeObserver(self)
    }
        
    @objc func switchToVoice(btn : UIButton) {
        if photoIsShow == true {
            photoPickerBtn(btn: photoChooseBtn)
        }
        
        if speakBtn.isHidden == true {
            if checkMicrophonePermissions() {
                btn.isSelected = true
                speakBtn.isHidden = false
                let tempS = inputTextView.text ?? ""
                inputTextView.text = ""
                textViewDidChange(inputTextView)
                draftS = tempS
                inputTextView.resignFirstResponder()
            }else{
                authorizationForMicrophone(confirmBlock: {[weak self]()in
                    DispatchQueue.main.async {
                        btn.isSelected = true
                        self?.speakBtn.isHidden = false
                        self?.inputTextView.text = ""
                        self?.inputTextView.resignFirstResponder()
                    }
                })
            }
        }else{
            btn.isSelected = false
            speakBtn.isHidden = true
            inputTextView.text = draftS
            textViewDidChange(inputTextView)
            inputTextView.becomeFirstResponder()
        }
    }
        
    @objc func photoPickerBtn(btn : UIButton) {
        if photoIsShow == false {
            switchBtn.isSelected = false
            speakBtn.isHidden = true
            
            inputTextView.text = ""
            textViewDidChange(inputTextView)
            inputTextView.resignFirstResponder()
            
            if checkPhotoLibraryPermissions() {
                btn.isSelected = true
                showPhotoPickV(show: true)
            }else{
                authorizationForPhotoLibrary(confirmBlock: { [weak self]()in
                    DispatchQueue.main.async {
                        btn.isSelected = true
                        self?.showPhotoPickV(show: true)
                    }
                })
            }
        }else{
            btn.isSelected = false
            showPhotoPickV(show: false)
        }
    }
    
    func showPhotoPickV(show : Bool){
        if show == true{
            photoIsShow = true
            
            let space = AppDelegate.shareIntance.space
            photoPickV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 44 - space.topSpace, width: SCREEN_WIDTH, height: CGFloat(PhotoPickerViewHeight))
            testVC?.view.addSubview(photoPickV)
            
            photoPickV.contId = consultId
            photoPickV.photoArray = ResourceShare.shareIntance.systemPhoto
            
            var rect = self.frame
            rect.origin.y = rect.origin.y - CGFloat(PhotoPickerViewHeight)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = rect
                self.photoPickV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 44 - space.topSpace - space.bottomSpace - CGFloat(PhotoPickerViewHeight), width: SCREEN_WIDTH, height: CGFloat(PhotoPickerViewHeight))
            })
        }else{
            photoIsShow = false
            
            var rect = self.frame
            rect.origin.y = rect.origin.y + CGFloat(PhotoPickerViewHeight)
            
            let space = AppDelegate.shareIntance.space
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = rect
                self.photoPickV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 44 - space.topSpace, width: SCREEN_WIDTH, height: CGFloat(PhotoPickerViewHeight))
            }, completion: { (b) in
                self.photoPickV.removeFromSuperview()
            })
        }
    }
        
    @objc func templateBtn(btn : UIButton) {
        if photoIsShow == true {
            photoPickerBtn(btn: photoChooseBtn)
        }
        let VC = TemplateTableViewController()
        VC.setTextBlock = {[weak self](s)->()in
            self?.setTextViewContent(t: s)
        }
        testVC?.navigationController?.pushViewController(VC, animated: true)
    }
    
    func setTextViewContent(t : String){
        inputTextView.text = t
        textViewDidChange(inputTextView)
        if speakBtn.isHidden == false{
            speakBtn.isHidden = true
            switchBtn.isSelected = false
        }
        inputTextView.becomeFirstResponder()
    }
    
    @objc func speakBtnTouchDown(btn : UIButton) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: self.directoryURL()! as URL, settings: recordSettings)//初始化实例
            audioRecorder?.prepareToRecord()//准备录音
            try audioSession.setActive(true)
            audioRecorder?.record()
        } catch {
        }
        
        voiceRecordingV.show()
    }
        
    @objc func speakBtnTouchUpInside(btn : UIButton) {
        audioRecorder?.stop()
    
        voiceConfirmView.frame = CGRect.init(x: 0, y: 44, width: SCREEN_WIDTH, height: 44)
        self.addSubview(voiceConfirmView)
        UIView.animate(withDuration: 0.5) {
            self.voiceConfirmView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44)
        }
        
        voiceRecordingV.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            let url = audioRecorder?.url as! URL
            try audioPlayer = AVAudioPlayer.init(contentsOf: url)
            audioPlayer?.prepareToPlay()
            let num = NSInteger((audioPlayer?.duration)!)
            voiceConfirmView.auditionBtn.secondsLabel.text = String.init(format: "%d'", num)
            convertAudio()
        } catch {
            HCPrint(message: "出错！")
        }
    }
        
    @objc func speakBtnDragOutside(btn : UIButton) {
        HCPrint(message: "dragOutside")
        voiceRecordingV.infoL.text = "松开手指，取消录音"
    }
    
    @objc func speakBtnDragInside(btn : UIButton) {
        HCPrint(message: "dragInside")
        voiceRecordingV.infoL.text = "上滑手指，取消录音"
    }
        
    @objc func speakBtnTouchUpOutside(btn : UIButton) {
        audioRecorder?.stop()
        audioRecorder?.deleteRecording()
        
        voiceRecordingV.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
        }
    }
    
}
    
extension InputView : UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if photoIsShow == true {
            photoPickerBtn(btn: photoChooseBtn)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var contentH = textView.contentSize.height + 6
        if contentH < 44 {
            contentH = 44
        }
        let originY = self.frame.origin.y
        let originH = self.frame.size.height
        self.frame = CGRect.init(x: 0, y: originY + originH - contentH, width: SCREEN_WIDTH, height: contentH)
        draftS = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //  回复文字
        if text.compare("\n") == ComparisonResult.orderedSame {
            textView.resignFirstResponder()
            if textView.text != nil {
                SVProgressHUD.show()
                HttpRequestManager.shareIntance.reply((UserManager.shareIntance.currentUser?.token)!, doctorId: self.doctorId!, consultationId: (consultId?.intValue)!, content: textView.text, urlList: "", type: "0", callback: { [weak self](success, message) in
                    if success == true {
                        HCShowInfo(info: "文字发送成功！")
                        textView.text = ""
                        self?.textViewDidChange(textView)
                        self?.draftS = ""
                        self?.removeFromSuperview()
                        let note = Notification.init(name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
                        NotificationCenter.default.post(note)
                    }else{
                        HCShowError(info: "文字发送失败！")
                    }
                })
            }else{
                HCShowError(info: "请输入文字！")
            }
            return false
        }
        return true
    }
    
}
    
extension InputView {
    func convertAudio(){
        let finalUrlString = amrPath()
        DispatchQueue.global().async {[unowned self]()in
            VoiceConverter.convertWav(toAmr: self.currentAudioPath, amrSavePath: finalUrlString)
        }
    }
    
    func directoryURL() -> URL? {
        let urlString = recordPath()
        currentAudioPath = urlString
        let soundURL = URL.init(string: urlString)
        return soundURL
    }
    
    func recordPath()->String{
        let recordingName =  "/recorder.wav"
        let sourceUrlString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + recordingName
        return sourceUrlString
    }
    
    func amrPath()->String{
        let finalName = "/recording.amr"
        let finalUrlString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + finalName
        return finalUrlString
    }
}

extension InputView {
    
    @objc func keboardWillShow(anotification : NSNotification) {
        let space = AppDelegate.shareIntance.space
        let keboardFrame = anotification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        extraH = keboardFrame.height
        var tFrame = self.frame;
        tFrame.origin.y = keboardFrame.origin.y - tFrame.size.height - 44 - space.topSpace
        UIView.animate(withDuration: 0.25) { [unowned self]() in
            self.frame = tFrame
        }
        if let block = contentSizeBlock{
            block(extraH)
        }
    }
    
    @objc func keboardWillDismiss(anotification : NSNotification){
        if let block = contentSizeBlock{
            block(-extraH)
        }
        let space = AppDelegate.shareIntance.space
        var dFrame = self.frame;
        dFrame.origin.y = SCREEN_HEIGHT - dFrame.size.height - 44 - space.topSpace - space.bottomSpace
        UIView.animate(withDuration: 0.25) { [unowned self]() in
            self.frame = dFrame
        }
    }
}
