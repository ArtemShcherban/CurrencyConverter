//
//  ConverterCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 15.08.2022.
//

import UIKit

final class ConverterCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ConverterCell.self)
    private var row: Int?
    
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    
    weak var delegate: CentralViewDelegate?
    
    func configureAt(row: Int, with currency: Currency, and amount: Double) {
        self.row = row + 1
        currencyButton.setTitle(currency.code, for: .normal)
        amountLabel.text = amount.decimalFormattedString()
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        guard let row = row else { return }
        delegate?.changeCurrency(at: row)
    }
}
