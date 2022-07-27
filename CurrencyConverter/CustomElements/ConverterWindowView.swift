//
//  PopUpWindow.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.07.2022.
//

import UIKit

@IBDesignable
final class ConverterWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var usdTextField: AdjustableTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        Bundle.main.loadNibNamed("ConverterWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
}
