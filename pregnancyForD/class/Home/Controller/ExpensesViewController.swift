//
//  ExpensesViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/17.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class ExpensesViewController: UIViewController {
    
    let ReuseIdentifier = "ReuseIdentifier"
    
    var patientModel : PatientModel?
    var textChangeBlock : changeBlock?
    
    var isDoctor : Bool?
    
    let array : [NSInteger] = [0, 20, 30, 50]
    
    let inputF = UITextField()
    let editBtn = UIButton()
    
    var collectionV : UICollectionView?

    var selectedRow : NSInteger? {
        didSet{
            inputF.text = String.init(format: "%d", array[selectedRow!])
        }
    }
    
    var widthDic = [NSInteger : CGFloat]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "资费标准"
        
        self.view.backgroundColor = kDefaultTabBarColor
        
        initUI()
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
        inputF.font = UIFont.systemFont(ofSize: 15)
        inputF.keyboardType = UIKeyboardType.numbersAndPunctuation
        
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
            make.width.equalTo(70)
        }
        editBtn.setTitle("确定", for: .normal)
        editBtn.layer.cornerRadius = 5
        editBtn.titleLabel?.textColor = UIColor.white
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        editBtn.backgroundColor = kDefaultThemeColor
        editBtn.addTarget(self, action: #selector(ExpensesViewController.textConfirmAction), for: .touchUpInside)
        
        
        let infoL = UILabel()
        self.view.addSubview(infoL)
        
        infoL.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(KDefaultPadding)
            make.top.equalTo(inputF.snp.bottom).offset(14)
            make.width.equalTo(150)
            make.height.equalTo(15)
        }
        
        infoL.text = "选择资费标准"
        infoL.font = UIFont.systemFont(ofSize: 15)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100), collectionViewLayout: layout)
        self.view.addSubview(collectionV!)
        collectionV?.snp.updateConstraints { (make) in
            make.top.equalTo(infoL.snp.bottom).offset(14)
            make.right.equalTo(self.view).offset(-KDefaultPadding)
            make.left.equalTo(self.view).offset(KDefaultPadding)
            make.bottom.equalTo(self.view)
        }
        collectionV?.dataSource = self
        collectionV?.delegate = self
        collectionV?.register(GroupManagerViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
        collectionV?.backgroundColor = kDefaultTabBarColor
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ExpensesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier, for: indexPath) as! GroupManagerViewCell
        let i = array[indexPath.row]
        var indexS : String = ""
        if i == 0 {
            indexS = "免费"
        }else{
            indexS = String.init(format: "%d 元/次", i)
        }
        cell.contentS = indexS
        
        cell.chooseBlock = {[unowned self](s)in
                self.selectedRow = indexPath.row
        }
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if widthDic[indexPath.row] == nil{
            let tempCell = GroupManagerViewCell()
            let i = array[indexPath.row]
            var indexS : String = ""
            if i == 0 {
                indexS = "免费"
            }else{
                indexS = String.init(format: "%d 元/次", i)
            }
            tempCell.contentS = indexS
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

extension ExpensesViewController {
    @objc func textConfirmAction(){
        if inputF.text == "" || inputF.text == nil {
            HCShowError(info: "请输入资费！")
        }else{
            let scanner = Scanner(string: inputF.text!)
            var number : Float = 0
            scanner.scanFloat(&number)
            
            let uploadNum = Int(number * 100)

            if isDoctor == nil || isDoctor == false {
                updateCost(num: uploadNum) { [unowned self](success, message) in
                    if success == true {
                        HCShowInfo(info: "更新成功！")
                        if let textChangeBlock = self.textChangeBlock {
                            var newS = ""
                            if number == 0 || number < 0.01{
                                newS = "0"
                            }else{
                                newS = String.init(format: "%.2f", number)
                            }
                            textChangeBlock(newS)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        HCShowError(info: "更新失败！")
                    }
                }
            }else{
                updateDoctorInfo(key: "price", value: uploadNum, callback: { (success, message) in
                    if success == true {
                        HCShowInfo(info: "更新成功！")
                        if let textChangeBlock = self.textChangeBlock {
                            textChangeBlock("")
                        }
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        HCShowError(info: "更新失败！")
                    }
                })
            }
        }
    }
    
    
    func updateCost(num : Int, callback : @escaping (_ success : Bool, _ message : String)->()){
        HttpRequestManager.shareIntance.updatePatientInfo((UserManager.shareIntance.currentUser?.token)!, patientId: (patientModel?.p_id?.intValue)!, type: 1, value: num ) { (success, message) in
            callback(success, message)
        }
    }
    
    func updateDoctorInfo(key : String, value : Int, callback : @escaping (_ success : Bool, _ message : String)->()){
        let infoDic = [key : value]
        HttpRequestManager.shareIntance.updateinfo((UserManager.shareIntance.currentUser?.token)!, infoDic: infoDic as NSDictionary) { (success, message) in
            callback(success, message)
        }
    }
}

