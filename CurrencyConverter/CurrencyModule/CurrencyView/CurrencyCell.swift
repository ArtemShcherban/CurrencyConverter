//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 25.07.2022.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CurrencyCell.self)
    
    private let currencyDataSource = CurrencyDataSource.shared
    
    /// Сonfigures the cell with complete data
    func configure(with indexPath: IndexPath) {
        var content = defaultContentConfiguration()
        let currenciesGroup = currencyDataSource.currencyGroups[indexPath.section]
        let currency = currenciesGroup.currencies[indexPath.row].currency
        let currencyName = currenciesGroup.currencies[indexPath.row].currencyName
        content.attributedText = createTitle(currency, currencyName)
        contentConfiguration = content
    }
    /// Configures a cell with filtered data
    func configureWith(indexPath: IndexPath) {
        var content = defaultContentConfiguration()
        let currency = currencyDataSource.filteredCurrency[indexPath.row].currency
        let currencyName = currencyDataSource.filteredCurrency[indexPath.row].currencyName
        content.attributedText = createTitle(currency, currencyName)
        contentConfiguration = content
    }
    
    func createTitle(_ currency: String, _ currencyName: String) -> NSMutableAttributedString {
        let attridutedString = NSMutableAttributedString(string: currency, attributes: [
            NSAttributedString.Key.font:
                UIFont(
                    name: "Lato-SemiBold",
                    size: 17) ?? UIFont()
        ])
        let attributedCurrencyName = NSAttributedString(string: " - \(currencyName)", attributes: [
            NSAttributedString.Key.font:
                UIFont(
                    name: "Lato-Regular",
                    size: 17) ?? UIFont()
        ])
        attridutedString.append(attributedCurrencyName)
        return attridutedString
    }
}
