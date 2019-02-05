//
//  SuggestionCell.swift
//  ChatBotApp
//
//  Created by Sandiaa on 07/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import UIKit

class SuggestionCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var suggestionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 24
        baseView.layer.borderColor = UIColor.lightPurpleColor.cgColor
        baseView.layer.borderWidth = 1.0
        
        suggestionLabel.textColor = UIColor.lightPurpleColor

    }
    func populateWith(suggestion:ChatType) {
        suggestionLabel.text = suggestion.getChatText()
        layoutIfNeeded()
    }
}
