//
//  ConverterCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 15.08.2022.
//

import UIKit

final class ConverterCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ConverterCell.self)
   
    var currencyAction: (() -> Void)?
    
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    
    func configureAt(with currency: Currency, and amount: Double) {
        currencyButton.setTitle(currency.code, for: .normal)
        amountLabel.text = amount.decimalFormattedString()
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        guard let currencyAction = currencyAction else {
            return
        }
        currencyAction()
    }
}
