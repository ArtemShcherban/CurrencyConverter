//
//  AdjustableTextField.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 20.07.2022.
//

import UIKit

@IBDesignable
final class AdjustableTextField: UITextField {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
}
