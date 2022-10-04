//
//  HeaderBackgroundView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 20.07.2022.
//

import UIKit

@IBDesignable
final class HeaderBackgroundView: UIView {
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("HeaderBackgroundView", owner: self, options: nil)
        contentView.embedded(in: self)
    }
}
