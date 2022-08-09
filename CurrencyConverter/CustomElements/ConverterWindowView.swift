//
//  PopUpWindow.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.07.2022.
//

import UIKit

protocol ConverterWindowViewDelegate: AnyObject {
}

@IBDesignable
final class ConverterWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var usdTextField: AdjustableTextField!
    @IBOutlet weak var rotateButton: UIButton!
    
    weak var delegate: ConverterWindowViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configure()
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("ConverterWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    private func configure() {
        transform = CGAffineTransform(scaleX: 0.001, y: 1)
    }
    
    @IBAction func rotateButtonPressed(_ sender: Any) {
        popUpWindowDelegate?.rotateButtonPressed()
    }
}
