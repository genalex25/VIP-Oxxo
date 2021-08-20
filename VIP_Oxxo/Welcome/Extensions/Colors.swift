//
//  Colors.swift
//  Counters
//
//  Created by Genaro on 6/20/21.
//
import UIKit.UIColor
typealias Color   = UIColor

extension Color {
    convenience init(rgbaValue: UInt32) {
        let red   = CGFloat((rgbaValue >> 24) & 0xFF) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xFF) / 255.0
        let blue  = CGFloat((rgbaValue >> 8) & 0xFF) / 255.0
        let alpha = CGFloat(rgbaValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

enum AppColors {
    /// 255 149 0
    case mainTintColor
    /// 237 237 237
    case backgroundColor
    /// 136 139 144
    case darkSilverColor
    /// 220 220 223
    case inactiveCountLabelColor
    
    var rgbaValue: UInt32 {
        switch self {
        case .mainTintColor:
            return 0xFF9500FF
        case .backgroundColor:
            return 0xEDEDEDFF
        case .darkSilverColor:
            return 0x888B90FF
        case .inactiveCountLabelColor:
            return 0xDCDCDFFF
        }
    }
    
    var color: Color {
        return Color(named: self)
    }
}

extension Color {
    convenience init(named name: AppColors) {
        self.init(rgbaValue: name.rgbaValue)
    }
}

