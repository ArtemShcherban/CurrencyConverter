//
//  RateCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

final class RateCell: UITableViewCell {
    static let reuseIdentifier = String(describing: RateCell.self)
    
    @IBOutlet private weak var currencyButton: UIButton!
    @IBOutlet private weak var buyLabel: RateTextLabel!
    @IBOutlet private weak var sellLabel: RateTextLabel!
    
    private var row: Int?
    weak var delegate: CentralViewDelegate?
    
    func configureAt(row: Int, with currency: Currency) {
        self.row = row
        currencyButton.setTitle(currency.code, for: .normal)
        buyLabel.text = String(format: "%.3f", currency.buy)
        sellLabel.text = String(format: "%.3f", currency.sell)
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        guard let row = row else { return }
        delegate?.changeCurrency(at: row)
    }
}
