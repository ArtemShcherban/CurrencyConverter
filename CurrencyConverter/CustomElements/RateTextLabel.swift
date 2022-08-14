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
            layer.borderWidth = borderWidth
        }
    }
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
}
