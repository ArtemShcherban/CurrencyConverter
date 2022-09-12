//
//  InfoLabel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 11.09.2022.
//

import UIKit

class InfoLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.46
        attributedText = NSAttributedString(
            string: " ",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont()
            ])
    }
    
    func setConstraints() {
        guard let superview = superview as? MainView else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.containerView.leadingAnchor),
            topAnchor.constraint(equalTo: superview.converterView.bottomAnchor, constant: 2),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 123)
        ])
    }
}
