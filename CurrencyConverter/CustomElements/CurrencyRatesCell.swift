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
    @IBOutlet private weak var buyLabel: RateTextLabel!
    @IBOutlet private weak var sellLabel: RateTextLabel!
    
    private lazy var dataSource = RatesDataSource.shared
    weak var delegate: RatesWindowViewDelegate?
    
    func configure(with indexPath: IndexPath) {
        let code = dataSource.currenciesDisplayed[indexPath.row].code
        currencyButton.setTitle(code, for: .normal)
        currencyButton.tag = indexPath.row
        buyLabel.text = String(format: "%.3f", dataSource.currenciesDisplayed[indexPath.row].buy)
        sellLabel.text = String(format: "%.3f", dataSource.currenciesDisplayed[indexPath.row].sell)
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
