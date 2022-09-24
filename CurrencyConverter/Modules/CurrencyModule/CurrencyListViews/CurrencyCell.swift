//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 25.07.2022.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CurrencyCell.self)
    private let currencyDataSource = CurrencyListDataSource.shared
    
    /// Сonfigures the cell with complete data
    func configure(with indexPath: IndexPath) {
        var content = defaultContentConfiguration()
        let currency = currencyDataSource.currencyList
            .filter { $0.groupKey == currencyDataSource.groups
            .filter { $0.visible == true }[indexPath.section].key
            }[indexPath.row]
        content.attributedText = createTitle(currency.code, currency.currency)
        contentConfiguration = content
    }
    
    /// Configures the cell with filtered data
    func configureWith(indexPath: IndexPath) {
        var content = defaultContentConfiguration()
        let currency = currencyDataSource.filteredCurrency[indexPath.row]
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
