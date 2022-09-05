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
    
    weak var delegate: PopUpWindowDelegate?
    
    func configureAt(row: Int, with currency: Currency) {
        currencyButton.setTitle(currency.code, for: .normal)
        currencyButton.tag = row
        buyLabel.text = String(format: "%.3f", currency.buy)
        sellLabel.text = String(format: "%.3f", currency.sell)
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
