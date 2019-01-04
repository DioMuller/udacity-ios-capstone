//
//  RoundedButton.swift
//  AdLudum
//
//  Created by Diogo Muller on 25/11/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

// Based on https://spin.atomicobject.com/2017/07/18/swift-interface-builder/
@IBDesignable
class RoundedButton: UIButton {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBInspectable Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

}
