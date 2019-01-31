//
//  DatePickerExtension.swift
//  ChatOnboarding
//
//  Created by Manoj Kumar on 22/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import Foundation
import UIKit

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}


extension ChatController {
    func getDateInChatFormat(date : Date) -> (String) {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMM"
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        
        let dateStr = dateFormater.string(from: date)
        let yearstr = yearFormatter.string(from: date)
        
        let finalStr = dateStr + "\n" + yearstr
        return finalStr
    }
}
