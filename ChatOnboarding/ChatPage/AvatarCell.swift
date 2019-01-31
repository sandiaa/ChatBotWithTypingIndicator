//
//  AvatarCell.swift
//  ChatOnboarding
//
//  Created by Manoj Kumar on 23/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
         baseView.layer.cornerRadius = 10
        img.layer.cornerRadius = 10
    }

}
