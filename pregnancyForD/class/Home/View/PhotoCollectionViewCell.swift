//
//  PhotoCollectionViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/14.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectBtn.contentMode = .center
    }

}
