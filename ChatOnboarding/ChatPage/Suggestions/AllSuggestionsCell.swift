//
//  AllSuggestionsCell.swift
//  ChatBotApp
//
//  Created by Admin on 08/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol AllSuggestionsCellDelegate:class {
    func didSelectSuggestion(suggestion:ChatType)
}

class AllSuggestionsCell: UICollectionViewCell {
    
    weak var delegate:AllSuggestionsCellDelegate?

    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    
    var allSuggestions = [ChatType]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        suggestionsCollectionView.register(UINib(nibName: "SuggestionCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionCell")
        
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        
        let layout = CenterAlignedFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 20.0
        suggestionsCollectionView.setCollectionViewLayout(layout, animated: false)
        
        suggestionsCollectionView.reloadData()
    }

    func populateWith(userSuggestions:[ChatType]) {
        allSuggestions = userSuggestions
        suggestionsCollectionView.reloadData()
    }
}


extension AllSuggestionsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSuggestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
        cell.populateWith(suggestion: allSuggestions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = allSuggestions[indexPath.row]
        
        let lbl = UILabel()
        lbl.text = message.getChatText()
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 17)
        
        let size = lbl.sizeThatFits(CGSize(width: CGFloat.infinity, height: 50))
        
        return CGSize(width: max(size.width + 20, 100), height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSuggestion = allSuggestions[indexPath.row]
        delegate?.didSelectSuggestion(suggestion: selectedSuggestion)

    }
}
