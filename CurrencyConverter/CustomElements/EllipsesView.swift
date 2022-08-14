//
//  EllipssesView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 20.07.2022.
//

import UIKit

@IBDesignable
final class EllipsesView: UIView {
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
        Bundle.main.loadNibNamed("EllipsesView", owner: self, options: nil)
        contentView.fixInView(self)
    }
}
