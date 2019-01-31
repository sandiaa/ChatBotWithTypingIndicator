//
//  StringExtension.swift
//  ChatOnboarding
//
//  Created by Manoj Kumar on 18/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var isEmail:Bool {
        let regExPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regExPattern)
        if (!self.containsEmoji && predicate.evaluate(with: self)) {
            return true;
        }
        return false;
    }
    var isName:Bool {
            let RegEx = "^\\w{5,18}$"
            let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        if (!self.containsEmoji && Test.evaluate(with: self)) {
            return true;
        }
        return false;
    }
    
    
    var isDecimalOnly:Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    func trim()->String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// FOR EMOJIS
extension String {
    var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    var emojiString: String {
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
    
    var isDob : Bool {
        return true
    }
}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}
extension String {
//    func verifyForPassword() -> (Bool, String?) {
//        if count == 0 {
//            return (false, "porfavor ingrese una contraseña")
//        }
//        if count < 6 || containsEmoji {
//            return (false,"Por favor introduce una contraseña válida")
//        }
//        return(true, nil)
//    }
    
//    func verifyForTabellaConfirmPassword() -> (Bool, String?) {
//
//        if count == 0 {
//            return (false, "Por favor confirme la contraseña")
//        }
//
//        if containsEmoji {
//            return (false, "Por favor introduce una contraseña válida")
//        }
//
//        if count < 6 {
//            return (false, "Por favor introduce una contraseña válida")
//        }
//        return(true, nil)
//    }
    
    func checkIfBothAreSame(firstString : String, otherString:String)->Bool {

      //  if firstString.trim().uppercased() == otherString.trim().uppercased() {
        if firstString.trim() == otherString.trim() {
            return true
        }

        return false
    }
}
