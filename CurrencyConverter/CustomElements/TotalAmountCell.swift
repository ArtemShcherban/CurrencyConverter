//
//  TotalAmountCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 15.08.2022.
//

import UIKit

class TotalAmountCell: UITableViewCell {
    static let reuseIdentifier = String(describing: TotalAmountCell.self)
    
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    weak var delegate: PopUpWindowDelegate?
    
    func configureAt(row: Int, with currency: Currency, and amount: Double) {
        currencyButton.setTitle(currency.code, for: .normal)
        currencyButton.tag = row + 1
        totalAmountLabel.text = amount.decimalFormat()
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
