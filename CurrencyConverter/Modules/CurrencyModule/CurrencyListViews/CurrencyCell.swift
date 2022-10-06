//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 25.07.2022.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CurrencyCell.self)

    func configure(with currency: Currency) {
        var content = defaultContentConfiguration()
        content.attributedText = createTitle(currency.code, currency.currency)
        contentConfiguration = content
    }
    
    private func createTitle(_ code: String, _ currency: String) -> NSMutableAttributedString {
        let attridutedString = NSMutableAttributedString(string: code, attributes: [
            NSAttributedString.Key.font: FontConstants.latoSemiBold
        ])
        let attributedCurrencyName = NSAttributedString(string: " - \(currency)", attributes: [
            NSAttributedString.Key.font: FontConstants.latoRegular
        ])
        attridutedString.append(attributedCurrencyName)
        return attridutedString
    }
}
