//
//  ChatPicTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ChatPicTableViewCell: BaseChatTableViewCell {
    
    let reuseIdentifierForImg = "reuseIdentifierForImg"
    
    lazy var imgCollV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize.init(width: PhotoesWidth, height: PhotoesWidth)
        
        let c = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: PhotoesWidth), collectionViewLayout: layout)
        c.backgroundColor = UIColor.clear
        c.dataSource = self
        c.delegate = self
        return c
    }()
    
    var imgStrs : [String]? {
        didSet{
            imgCollV.reloadData()
        }
    }
    
    lazy var nameL : UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.font = UIFont.init(name: kReguleFont, size: 12)
        l.textAlignment = NSTextAlignment.center
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(imgCollV)
        imgCollV.register(ConsultCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierForImg)
        
        indexBlock = {[weak self](row)in
            let indexPath = IndexPath.init(row: row, section: 0)
            let cell = self?.imgCollV.cellForItem(at: indexPath) as! ConsultCollectionViewCell
            //获取cell中心
            let p = self?.imgCollV.convert(cell.center, to: self)
            if let block = self?.convertBlock {
                self?.cellCenter = block(p!)
            }
            self?.cellImage = cell.imgV.image!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var viewModel: ConsultViewmodel? {
        didSet{
            imgCollV.frame = viewModel?.picF ?? CGRect.zero
            
            imgStrs = viewModel?.model?.imageList
            
            nameL.frame = viewModel?.nameF ?? CGRect.zero
            nameL.text = viewModel?.model?.doctName
        }
    }
    
    func getPhotoCenter()->CGPoint{
        HCPrint(message: "PIC ****    *****")
        return cellCenter
    }
    
    func getImage()->UIImage{
        HCPrint(message: "PIC ****    *****")
        return cellImage
    }
    
    func updateCenterAndImage(note : Notification){
        let row = note.userInfo?["row"] as! NSInteger
        let indexPath = IndexPath.init(row: row, section: 0)
        let cell = imgCollV.cellForItem(at: indexPath) as! ConsultCollectionViewCell
        //获取cell中心
        let p = imgCollV.convert(cell.center, to: self)
        if let block = convertBlock {
            cellCenter = block(p)
        }
        cellImage = cell.imgV.image!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ChatPicTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgStrs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierForImg, for: indexPath) as! ConsultCollectionViewCell
        cell.urlS = imgStrs?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ConsultCollectionViewCell
        //获取cell中心
        HCPrint(message: cell.center)
        let p = collectionView.convert(cell.center, to: self)
        HCPrint(message: p)
        if let block = convertBlock {
            cellCenter = block(p)
            HCPrint(message: cellCenter)
        }
        cellImage = cell.imgV.image!
        if let block = showPhotoBlock {
            block(imgStrs!, indexPath.row)
        }
    }
}
