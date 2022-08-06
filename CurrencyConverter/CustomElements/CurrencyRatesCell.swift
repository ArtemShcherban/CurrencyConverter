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
    
    private lazy var dataSource = RatesDataSource.shared
    weak var delegate: RatesWindowViewDelegate?
    
    func configure(with indexPath: IndexPath) {
        let code = dataSource.currenciesDisplayed[indexPath.row].code
        currencyButton.setTitle(code, for: .normal)
        currencyButton.tag = indexPath.row
        buyRateLabel.text = String(0.00) // String(format: "%.3f", oldCurrencyDataSourceOLD.rates[code]?.rateBuy ?? 0.0)
        sellRateLabel.text = String(0.00) // String(format: "%.3f", oldCurrencyDataSourceOLD.rates[code]?.rateSell)
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
