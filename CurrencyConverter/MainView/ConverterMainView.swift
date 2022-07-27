//
//  ConverterMainView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

class ConverterMainView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var popUpWindow: ConverterWindowView!
    @IBOutlet weak var ratesWindowView: RatesWindowView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("ConverterMainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func square(_ number: Int) -> String {
        let square = number * number
        return "Square of \(number) is \(square)"
    }
}
