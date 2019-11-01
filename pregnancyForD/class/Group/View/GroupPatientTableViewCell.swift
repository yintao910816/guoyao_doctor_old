//
//  GroupPatientTableViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/11.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class GroupPatientTableViewCell: UITableViewCell {

    @IBOutlet weak var infomationL: UILabel!
    
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    var model : PatientModel? {
     
        didSet (old){
            
            if let name = model?.patientName {
                nameL.text = name
            }else{
                nameL.text = "匿名"
            }

            nameL.sizeToFit()
            
            if model?.patientSex?.intValue == 1 {
                sexImageView.image = UIImage.init(named: "HC-nan")
            }else{
                sexImageView.image = UIImage.init(named: "HC-nv")
            }

            if let age = model?.patientAge{
                infomationL.text = String.init(format: "%d 岁", age.intValue)
            }else{
                infomationL.text = ""
            }
            infomationL.sizeToFit()
            
            if let imgS = model?.headImg{
                headImageView.HC_setImageFromURL(urlS: imgS, placeHolder: "HC_moren-5")
            }else{
                headImageView.image = UIImage.init(named: "HC_moren-5")
            }
            
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        headImageView.layer.cornerRadius = 18
        headImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
