//
//  RateCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

final class RateCell: UITableViewCell {
    static let reuseIdentifier = String(describing: RateCell.self)
    
    var currencySelectAction: (() -> Void)?
    
    @IBOutlet private weak var currencyButton: UIButton!
    @IBOutlet private weak var buyLabel: RateTextLabel!
    @IBOutlet private weak var sellLabel: RateTextLabel!
    
    func configureAt(with currency: Currency) {
        currencyButton.setTitle(currency.code, for: .normal)
        buyLabel.text = String(format: "%.3f", currency.buy)
        sellLabel.text = String(format: "%.3f", currency.sell)
    }
    
    @IBAction func currencyTapped() {
        guard let currencyAction = currencySelectAction else {
            return
        }
        currencyAction()
    }
}
