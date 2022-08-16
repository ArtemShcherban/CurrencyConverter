//
//  InputAmountCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 09.08.2022.
//

import UIKit

protocol InputAmountFieldDeligate: UITextFieldDelegate {
    func amountChanged(in textField: AdjustableTextField)
}

class InputAmountCell: UITableViewCell {
    static let reuseIdentifier = String(describing: InputAmountCell.self)
    
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var inputAmountField: AdjustableTextField!
    
    private lazy var resultDataSource = ResultDataSource.shared

    weak var delegate: PopUpWindowDelegate?
    weak var inputAmountFieldDelegate: InputAmountFieldDeligate?
    
    func configure(with indexPath: IndexPath) {
        let currency = resultDataSource.selectedCurrencies[indexPath.row]
        currencyButton.setTitle(currency.code, for: .normal)
        currencyButton.tag = indexPath.row
        inputAmountField.delegate = inputAmountFieldDelegate
        inputAmountField.addTarget(
            self,
            action: #selector(amountChanged),
            for: .editingChanged)
    }
    
    @objc func amountChanged(_ sender: AdjustableTextField) {
        inputAmountFieldDelegate?.amountChanged(in: sender)
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
