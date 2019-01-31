//
//  UserCell.swift
//  ChatBotApp
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var baseView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 10
 
    }
    
    func populateWith(chatType : ChatType) {
        if chatType == .signupRegisteredDob {
            textLabel.attributedText = chatType.modifyText(txt: chatType.getChatText())
            textLabel.numberOfLines = 0
         }
        else {
            textLabel.text = chatType.getChatText()
        }
        
        layoutIfNeeded()
    }

}
