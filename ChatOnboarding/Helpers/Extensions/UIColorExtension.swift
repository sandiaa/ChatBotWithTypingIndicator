//
//  UIColorExtension.swift
//  ChatBotApp
//
//  Created by Admin on 08/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /**
     Create a UIColor object by passing hex values
     
     - Parameter fromHex: The hex value for the color in the format 0xFFFFFF
     - Returns: A UIColor object
     
     ### Usage Example: ###
     ````
     let colorView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     colorView.backgroundColor = UIColor.rgb(fromHex: 0xFF0000)
     view.addSubview(colorView)
     */
    class func rgb(fromHex: Int) -> UIColor {
        let alpha = CGFloat(1.0)
        return UIColor.rgba(fromHex: fromHex, alpha: alpha)
    }
    
    /**
     Create a UIColor object with altered alpha by passing hex values
     
     - Parameter fromHex: The hex value for the color in the format 0xFFFFFF
     - Parameter alpha: The alpha value for the color
     - Returns: A UIColor object
     
     ### Usage Example: ###
     ````
     let colorView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
     colorView.backgroundColor = UIColor.rgba(fromHex: 0xFF0000, alpha:0.5)
     view.addSubview(colorView)
     */
    class func rgba(fromHex: Int, alpha: CGFloat) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func hex(hexString:String)->UIColor {
        let hexString: String       = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner                 = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UIColor {
    
    static let lightPurpleColor = UIColor.rgb(fromHex: 0x7f52d6)
    
    
}
