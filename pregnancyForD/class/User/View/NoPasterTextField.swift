//
//  NoPasterTextField.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/31.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class NoPasterTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        UIMenuController.shared.isMenuVisible = false
        return false
        
    }

}
