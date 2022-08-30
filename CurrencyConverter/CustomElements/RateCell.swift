//
//  RateCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

class RateCell: UITableViewCell {
    static let reuseIdentifier = String(describing: RateCell.self)
    
    @IBOutlet private weak var currencyButton: UIButton!
    @IBOutlet private weak var buyLabel: RateTextLabel!
    @IBOutlet private weak var sellLabel: RateTextLabel!
    
    private lazy var dataSource = ResultDataSource.shared
    private lazy var exchangeRateModel = ExchangeRateModel()
    
    weak var delegate: PopUpWindowDelegate?
    
    func configure(with indexPath: IndexPath) {
        var currency = dataSource.selectedCurrencies[indexPath.row]
        exchangeRateModel.setExchangeRate(for: &currency)
        currencyButton.setTitle(currency.code, for: .normal)
        currencyButton.tag = indexPath.row
        buyLabel.text = String(format: "%.3f", currency.buy)
        sellLabel.text = String(format: "%.3f", currency.sell)
    }
//    func configure(with indexPath: IndexPath) {
//        let currency = dataSource.selectedCurrencies[indexPath.row]
//        exchangeRateModel.setExchangeRate(for: currency)
//        currencyButton.setTitle(currency.code, for: .normal)
//        currencyButton.tag = indexPath.row
//        buyLabel.text = String(format: "%.3f", dataSource.selectedCurrencies[indexPath.row].buy)
//        sellLabel.text = String(format: "%.3f", dataSource.selectedCurrencies[indexPath.row].sell)
//    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
