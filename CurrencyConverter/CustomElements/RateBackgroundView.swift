//
//  RateBackgroundView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 04.10.2022.
//

import UIKit

@IBDesignable
final class RateBackgroundView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
}
