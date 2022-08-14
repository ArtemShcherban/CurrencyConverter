//
//  ConverterCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 09.08.2022.
//

import UIKit

class ConverterCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ConverterCell.self)
    
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var sumLabel: AdjustableTextField!
    
    private lazy var resultDataSource = ResultDataSource.shared
    weak var delegate: PopUpWindowDelegate?
    
    func configure(with indexPath: IndexPath) {
        let currencies = resultDataSource.selectedCurrencies
        currencyButton.setTitle(currencies[indexPath.row].code, for: .normal)
        currencyButton.tag = indexPath.row
        sumLabel.text = "0.000"
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
