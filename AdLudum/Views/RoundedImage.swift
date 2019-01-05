//
//  RoundedImage.swift
//  AdLudum
//
//  Created by Diogo Muller on 05/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

// Based on https://spin.atomicobject.com/2017/07/18/swift-interface-builder/
@IBDesignable
class RoundedImage: UIImageView {
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
            layer.masksToBounds = newValue != 0
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
