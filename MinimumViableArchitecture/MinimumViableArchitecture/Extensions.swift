//
//  Extensions.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import UIKit

var globalDateFormatter = DateFormatter()

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
    
    static var secondsInADay: Int {
        return 60 * 60 * 24
    }
    
    static var secondsInAYear: Int {
        return 365 * secondsInADay
    }
    
    var offsetForZeroBasedIndex: Int {
        guard self > 0 else { print("Unable to calculate zero offset, Index < 1: \(self)"); return 0 }
        
        return self - 1
    }
}

extension Int32 {
    var isEven: Bool {
        return self % 2 == 0
    }
}

extension Date {
    var string: String {
        globalDateFormatter.dateStyle = .long
        globalDateFormatter.timeStyle = .none
        
        return globalDateFormatter.string(from: self)
    }
}

extension NSDate {
    var string: String {
        return (self as Date).string
    }
}

extension UIColor {
    
    //https://gist.github.com/asarode/7b343fa3fab5913690ef
    static var random: UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    //http://stackoverflow.com/questions/36341358/how-to-convert-uicolor-to-string-and-string-to-uicolor-using-swift
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    
    // hue, saturation, brightness and alpha components from UIColor**
    var hsbComponents:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
            return (hue,saturation,brightness,alpha)
        }
        return (0,0,0,0)
    }
    
    var hexString:String {
        return String(format: "%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    
    var hexStringAlpha:String {
        return String(format: "%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
    }
}

extension Set {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension NSSet {
    var isEmpty: Bool {
        return self.count < 0
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

//http://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
extension Collection where Indices.Iterator.Element == Index {
    
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

