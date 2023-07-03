//
//  Extensions.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit

extension UIColor {
    static var whiteTheme: UIColor {
        #colorLiteral(red: 0.937254902, green: 0.9411764706, blue: 0.9568627451, alpha: 1)
    }
    
    static var choosenScopeButtonColor: UIColor {
        #colorLiteral(red: 0.1990236044, green: 0.3928955793, blue: 0.8773627877, alpha: 1)
    }
}

extension UIButton {
    var filterIsChosen: Bool {
        get {
            return objc_getAssociatedObject(self, &filterIsChosenKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &filterIsChosenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
private var filterIsChosenKey: UInt8 = 0

