//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 25.07.2022.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CurrencyCell.self)
    
    private let dataSource = CurrencyDataSource.shared
    
    /// Сonfigures the cell with complete data
    func configure(with indexPath: IndexPath) {
        var content = defaultContentConfiguration()
        let currency = dataSource.currencyList
            .filter { $0.groupKey == dataSource.groups
            .filter { $0.visible == true }[indexPath.section].key
            }[indexPath.row]
        content.attributedText = createTitle(currency.code, currency.currency)
        contentConfiguration = content
    }

    /// Configures the cell with filtered data
    func configureWith(indexPath: IndexPath) {
        var content = defaultContentConfiguration()
        let currency = dataSource.filteredCurrency[indexPath.row]
        content.attributedText = createTitle(currency.code, currency.currency)
        contentConfiguration = content
    }
    
    private func createTitle(_ code: String, _ currency: String) -> NSMutableAttributedString {
        let attridutedString = NSMutableAttributedString(string: code, attributes: [
            NSAttributedString.Key.font:
                UIFont(
                    name: "Lato-SemiBold",
                    size: 17) ?? UIFont()
        ])
        let attributedCurrencyName = NSAttributedString(string: " - \(currency)", attributes: [
            NSAttributedString.Key.font:
                UIFont(
                    name: "Lato-Regular",
                    size: 17) ?? UIFont()
        ])
        attridutedString.append(attributedCurrencyName)
        return attridutedString
    }
}
