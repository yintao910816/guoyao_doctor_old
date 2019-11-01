//
//  PhotoPickerView.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/10/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD

class PhotoPickerView: UIView {
    var contId : NSNumber?

    let PhotoReuseIdentifier = "PhotoReuseIdentifier"
    
    var photoCollectionView : UICollectionView!
    
    var selectRows = [NSInteger]()
    
    var photoArray : [UIImage]? {
        didSet{
            self.photoCollectionView.reloadData()
        }
    }
    
    var sendSuccessBlock : blankBlock?
    
    let photoBtn : PhotoPickerButton = PhotoPickerButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
    let picBtn : PhotoPickerButton = PhotoPickerButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
    
    let confirmBtn : UIButton = UIButton()
    let originalImageBtn : UIButton = UIButton()
    
    let chooseView : UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initPhotoCollectionView()
        initSelectButtonView()
        initConfirmButtonView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initPhotoCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        photoCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: Int(SCREEN_WIDTH) , height: PhotoPickerViewHeight - 44), collectionViewLayout: layout)
        
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoReuseIdentifier)
        photoCollectionView.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoReuseIdentifier)
        
        photoCollectionView.bounces = false
        
        self.addSubview(photoCollectionView)
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView.backgroundColor = UIColor.white
        photoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
    }
    
    func initSelectButtonView(){
        self.addSubview(chooseView)
        chooseView.snp.updateConstraints { (make) in
            make.top.left.equalTo(self)
            make.bottom.equalTo(self).offset(-44)
            make.width.equalTo(80)
        }
        chooseView.backgroundColor = UIColor.white
        
        let divisionVR = UIView()
        chooseView.addSubview(divisionVR)
        divisionVR.snp.updateConstraints { (make) in
            make.top.right.equalTo(chooseView)
            make.height.equalTo(chooseView)
            make.width.equalTo(1)
        }
        divisionVR.backgroundColor = kdivisionColor
        
        chooseView.addSubview(photoBtn)
        photoBtn.snp.updateConstraints { (make) in
            make.top.left.right.equalTo(chooseView)
            make.height.equalTo(chooseView).multipliedBy(0.5)
        }
        photoBtn.imageV.image = UIImage.init(named: "HC-photo")
        photoBtn.titleL.text = "拍照"
        photoBtn.addTarget(self, action: #selector(PhotoPickerView.takePhoto), for: .touchUpInside)
        
        let divisionV = UIView()
        chooseView.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.bottom.equalTo(photoBtn)
            make.width.equalTo(photoBtn)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        chooseView.addSubview(picBtn)
        picBtn.snp.updateConstraints { (make) in
            make.left.bottom.right.equalTo(chooseView)
            make.height.equalTo(chooseView).multipliedBy(0.5)
        }
        picBtn.imageV.image = UIImage.init(named: "HC-pic")
        picBtn.titleL.text = "相册"
        picBtn.addTarget(self, action: #selector(PhotoPickerView.systemPic), for: .touchUpInside)
        
    }
    
    func initConfirmButtonView(){
        let containerV = UIView()
        self.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(44)
        }
        containerV.backgroundColor = UIColor.white
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.top.equalTo(containerV)
            make.width.equalTo(containerV)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        containerV.addSubview(originalImageBtn)
        originalImageBtn.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(KDefaultPadding)
            make.top.equalTo(containerV).offset(2)
            make.bottom.equalTo(containerV).offset(-2)
            make.width.equalTo(100)
        }
        originalImageBtn.setTitle("原图", for: .normal)
        originalImageBtn.setTitleColor(kDefaultThemeColor, for: .normal)
        originalImageBtn.setImage(UIImage.init(named: "HC-weixuan"), for: .normal)
        originalImageBtn.setImage(UIImage.init(named: "HC-yixuan-"), for: .selected)
        originalImageBtn.addTarget(self, action: #selector(PhotoPickerView.originalAction), for: .touchUpInside)
        
        containerV.addSubview(confirmBtn)
        confirmBtn.snp.updateConstraints { (make) in
            make.right.equalTo(containerV).offset(-30)
            make.top.equalTo(containerV).offset(2)
            make.bottom.equalTo(containerV).offset(-2)
            make.width.equalTo(100)
        }
        confirmBtn.setTitle("发送", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.backgroundColor = UIColor.lightGray
        confirmBtn.isEnabled = false
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.addTarget(self, action: #selector(PhotoPickerView.sendAction), for: .touchUpInside)
    }
    
}

extension PhotoPickerView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.image = photoArray?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell {
            let photoCell = cell as! PhotoCollectionViewCell
            selectorPic(sender: photoCell.selectBtn, row: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 120, height: PhotoPickerViewHeight - 44)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
//        HCPrint(message: offsetX)
        if offsetX > 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.chooseView.alpha = 0.01
            })
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.chooseView.alpha = 1
            })
        }
    }
    
}

extension PhotoPickerView {
    
    @objc func takePhoto(){
        if checkCameraPermissions() {
            let photoVC = UIImagePickerController()
            photoVC.sourceType = .camera
            photoVC.allowsEditing = true
            photoVC.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
        }else{
            authorizationForCamera(confirmBlock: { [unowned self]()in
                let photoVC = UIImagePickerController()
                photoVC.sourceType = .camera
                photoVC.allowsEditing = true
                photoVC.delegate = self
                UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
            })
        }
    }
    
    @objc func systemPic(){
        let systemPicVC = UIImagePickerController()
        systemPicVC.sourceType = .photoLibrary
        systemPicVC.allowsEditing = true
        systemPicVC.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.present(systemPicVC, animated: true, completion: nil)
    }
    
    @objc func originalAction(){
        if originalImageBtn.isSelected == true{
            originalImageBtn.isSelected = false
        }else{
            originalImageBtn.isSelected = true
        }
    }
    
    func selectorPic(sender : UIButton, row : NSInteger){
        if sender.isSelected == true{
            sender.isSelected = false
            let index = selectRows.index(of: row)
            if let index = index {
                selectRows.remove(at: index)
            }
            checkExistSelectedImage()
        }else{
            if selectRows.count == 3 {
                HCShowError(info: "一次最多发送三张！")
            }else{
                sender.isSelected = true
                selectRows.append(row)
                checkExistSelectedImage()
            }
        }
    }
    
    func checkExistSelectedImage(){
        if selectRows.count > 0 {
            confirmBtn.backgroundColor = kDefaultThemeColor
            confirmBtn.isEnabled = true
        }else{
            confirmBtn.backgroundColor = UIColor.lightGray
            confirmBtn.isEnabled = false
        }
    }
    
    @objc func sendAction(){
        SVProgressHUD.show()
        DispatchQueue.global().async {[unowned self]()in
            var imageArr = [UIImage]()
            for i in self.selectRows {
                imageArr.append((self.photoArray?[i])!)
            }
            let consultID = self.contId?.intValue
            let doctorId = String.init(format: "%d", (UserManager.shareIntance.currentUser?.id?.intValue)!)
            
            
            
            let group = DispatchGroup.init()
            var pathArr = [String]()
            
            for p in imageArr{
                group.enter()
                HttpRequestManager.shareIntance.HC_uploadSingleImg(img: p, callback: { (bool, s) in
                    if bool {
                        pathArr.append(s)
                    }
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main) {[weak self]()in
                HCPrint(message: pathArr.count)
                HCPrint(message: pathArr)
                if pathArr.count == 0{
                    HCShowError(info: "上传图片失败")
                }else{
                    let s = pathArr.joined(separator: ",")
                    
                    HttpRequestManager.shareIntance.reply((UserManager.shareIntance.currentUser?.token)!, doctorId: doctorId, consultationId: consultID!, content: "", urlList: s, type: "3", callback: { [weak self](success, msg) in
                        if success == true {
                            HCShowInfo(info: "图片发送成功")
                            self?.removeFromSuperview()
                            self?.clearSelectedStatus()
                            if let block = self?.sendSuccessBlock {
                                block()
                            }
                            let note = Notification.init(name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
                            NotificationCenter.default.post(note)
                        }else{
                            HCShowError(info: "图片发送失败")
                        }
                    })
                }
            }
            

            //上传  回复  二合一
//            HttpRequestManager.shareIntance.uploadImage((UserManager.shareIntance.currentUser?.token)!, doctorId: doctorId, imageArr: imageArr, type: "3", consultationId: consultID!) { [weak self](success, message) in
//                if success == true {
//                    HCShowInfo(info: "图片发送成功！")
//                    self?.removeFromSuperview()
//                    self?.clearSelectedStatus()
//                    if let block = self?.sendSuccessBlock {
//                        block()
//                    }
//                    let note = Notification.init(name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
//                    NotificationCenter.default.post(note)
//                }else{
//                    HCShowError(info: "图片发送失败！")
//                }
//            }
            
            
        }
    }
    
    func clearSelectedStatus(){
        selectRows = [NSInteger]()
        confirmBtn.backgroundColor = UIColor.lightGray
        confirmBtn.isEnabled = false
        photoCollectionView.setContentOffset(CGPoint.init(x: -80, y: 0), animated: true)
        
        let cells = photoCollectionView.visibleCells
        for j in cells{
            let tempC = j as! PhotoCollectionViewCell
            tempC.selectBtn.isSelected = false
        }
    }
}

extension PhotoPickerView : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //拍照发送
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        //UIImagePickerControllerEditedImage   UIImagePickerControllerOriginalImage
        let image  = info["UIImagePickerControllerEditedImage"] as! UIImage
        let i = self.contId?.intValue
        let doctorId = String.init(format: "%d", (UserManager.shareIntance.currentUser?.id?.intValue)!)
        
        SVProgressHUD.show()
        
        
        HttpRequestManager.shareIntance.HC_uploadSingleImg(img: image, callback: { (bool, s) in
            if bool {
                
                HttpRequestManager.shareIntance.reply((UserManager.shareIntance.currentUser?.token)!, doctorId: doctorId, consultationId: i!, content: "", urlList: s, type: "3", callback: { [weak self](success, msg) in
                    if success == true {
                        HCShowInfo(info: "图片发送成功")
                        self?.removeFromSuperview()
                        self?.clearSelectedStatus()
                        if let block = self?.sendSuccessBlock {
                            block()
                        }
                        let note = Notification.init(name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
                        NotificationCenter.default.post(note)
                    }else{
                        HCShowError(info: "图片发送失败")
                    }
                })
        
            }else{
                HCShowError(info: "上传图片出错")
            }
        })
        
        
        
//        HttpRequestManager.shareIntance.uploadImage((UserManager.shareIntance.currentUser?.token)!, doctorId: doctorId, imageArr: [image], type: "3", consultationId: i!) { [weak self](success, message) in
//            if success == true {
//                HCShowInfo(info: "图片发送成功！")
//                self?.removeFromSuperview()
//                self?.clearSelectedStatus()
//                if let block = self?.sendSuccessBlock {
//                    block()
//                }
//                let note = Notification.init(name: NSNotification.Name.init(ReplyConsultSuccess), object: nil)
//                NotificationCenter.default.post(note)
//            }else{
//                HCShowError(info: "图片发送失败！")
//            }
//        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
        
        
}

