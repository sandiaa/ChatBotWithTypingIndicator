//
//  TypingCell.swift
//  ChatOnboarding
//
//  Created by Manoj Kumar on 25/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

class TypingCell: UICollectionViewCell {

    @IBOutlet weak var typeView: UIView!
    
    let activityIndicatorView = DGActivityIndicatorView(type:DGActivityIndicatorAnimationType.ballPulse, tintColor: UIColor.lightGray, size: 30.0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeView.layer.cornerRadius = 15
        activityIndicatorView!.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 30.0)
        activityIndicatorView?.backgroundColor = UIColor.clear
        typeView.addSubview(activityIndicatorView!)
        
        typeView.addShadowWith(shadowPath: UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 30), cornerRadius: 15).cgPath, shadowColor: UIColor.black.withAlphaComponent(0.1).cgColor, shadowOpacity: 1.0, shadowRadius: 10.0, shadowOffset: CGSize(width: 3, height: 3))
    }
}
