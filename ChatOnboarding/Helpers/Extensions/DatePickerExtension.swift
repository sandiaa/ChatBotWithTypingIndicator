//
//  DatePickerExtension.swift
//  ChatOnboarding
//
//  Created by Sandiaa on 22/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import Foundation
import UIKit

// Changes the date format.

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
