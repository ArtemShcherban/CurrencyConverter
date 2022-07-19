//
//  Oval.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 17.07.2022.
//

import UIKit

@IBDesignable final
class EllipseView: UIView {
    @IBInspectable var fillColor: UIColor = UIColor.gray
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
    }
}
