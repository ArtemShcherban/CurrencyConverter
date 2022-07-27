//
//  RateTextLabel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit
@IBDesignable
class RateTextLabel: UILabel {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.cornerRadius = 6
            layer.borderColor = borderColor?.cgColor
            clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
