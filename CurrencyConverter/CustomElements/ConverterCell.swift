//
//  ConverterCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 15.08.2022.
//

import UIKit

class ConverterCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ConverterCell.self)
    
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var row: Int?
    weak var delegate: CentralViewDelegate?
    
    func configureAt(row: Int, with currency: Currency, and amount: Double) {
        self.row = row + 1
        currencyButton.setTitle(currency.code, for: .normal)
        currencyButton.tag = row + 1
        totalAmountLabel.text = amount.decimalFormat()
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        guard let row = row else { return }
        delegate?.changeCurrency(at: row)
    }
}
