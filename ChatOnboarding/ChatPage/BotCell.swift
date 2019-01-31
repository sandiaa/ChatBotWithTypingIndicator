//
//  BotCell.swift
//  ChatBotApp
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

class BotCell: UICollectionViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
     baseView.layer.cornerRadius = 10
       
    }
    
    func populateWith(chatType : ChatType) {
        textLabel.text = chatType.getChatText()
        let lblSize = textLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 130, height: CGFloat.infinity))
        let returnigSize = CGSize(width:max(lblSize.width + 20, 100), height: max(lblSize.height + 20, 50))
        
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: returnigSize.width, height: returnigSize.height), cornerRadius: 10)
        let shadowColor = UIColor.black.withAlphaComponent(0.1)
        
        baseView.addShadowWith(shadowPath: shadowPath.cgPath, shadowColor: shadowColor.cgColor, shadowOpacity: 1.0, shadowRadius: 10, shadowOffset: CGSize(width: 3, height: 3))
        
        layoutIfNeeded()
    }
    
    
}
