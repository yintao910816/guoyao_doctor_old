//
//  PatientDetailTableViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/12.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class PatientDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var HCswitch: UISwitch!
    
    @IBOutlet weak var patientDetailTitle: UILabel!
    
    @IBOutlet weak var patientDetailContent: UILabel!
    
    @IBOutlet weak var patientYou: UIImageView!
    
    var shieldBlock : changeBlock?
    
    var changeSwitchBlock : changeBlock?
    
    var allowEdit : Bool = true {
        didSet{
            if allowEdit == false{
                HCswitch.isUserInteractionEnabled = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        HCswitch.isHidden = true
        patientYou.isHidden = true
        
        patientDetailTitle.font = UIFont.systemFont(ofSize: 17)
        patientDetailTitle.textColor = UIColor.lightGray
        
        patientDetailContent.font = UIFont.systemFont(ofSize: 17)
        patientDetailContent.textColor = kDefaultBlueColor
        
        //屏蔽事件
        HCswitch.addTarget(self, action: #selector(PatientDetailTableViewCell.shieldAction), for: .valueChanged)
        
        changeSwitchBlock = { [weak self](isOn)in
            if isOn == "0"{
                self?.HCswitch.setOn(false, animated: true)
            }else{
                self?.HCswitch.setOn(true, animated: true)
            }
            
        }
    }
    
    func changeSwitch(isOn : String){
        if isOn == "0"{
            HCswitch.setOn(false, animated: true)
        }else{
            HCswitch.setOn(true, animated: true)
        }
    }
    
    @objc func shieldAction(sender : UISwitch){
        if sender.isOn == true {
            if let shieldBlock = shieldBlock {
                shieldBlock("1")
            }
        }else{
            if let shieldBlock = shieldBlock {
                shieldBlock("0")
            }
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
