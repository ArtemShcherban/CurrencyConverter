//
//  CurrencyRatesCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

class CurrencyRatesCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CurrencyRatesCell.self)
    
    @IBOutlet private weak var currencyButton: UIButton!
    @IBOutlet private weak var buyRateLabel: RateTextLabel!
    @IBOutlet private weak var sellRateLabel: RateTextLabel!
    
    private lazy var currencyDataSource = CurrencyDataSource.shared
    
    func configure(with indexPath: IndexPath) {
        let currency = currencyDataSource.selectedCurrencies[indexPath.row].currency
        let code = currencyDataSource.selectedCurrencies[indexPath.row].code
        currencyButton.setTitle(currency, for: .normal)
        buyRateLabel.text = String(format: "%.3f", currencyDataSource.rates[code]?.rateBuy ?? 0.0)
        sellRateLabel.text = String(format: "%.3f", currencyDataSource.rates[code]?.rateSell ?? 0.0)
    }
}
