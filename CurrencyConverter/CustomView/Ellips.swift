//
//  Oval.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 17.07.2022.
//

import UIKit

@IBDesignable final
class Ellips: UIView {
    @IBInspectable var layerColor: UIColor = UIColor.gray

    override func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
        let ellipsPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        let ellipsShape = CAShapeLayer()
        ellipsShape.path = ellipsPath.cgPath
        ellipsShape.fillColor = layerColor.cgColor
        layer.addSublayer(ellipsShape)
    }
}
