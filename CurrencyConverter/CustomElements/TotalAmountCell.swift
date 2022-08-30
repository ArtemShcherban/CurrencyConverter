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
    
    private lazy var resultDataSource = ResultDataSource.shared
    private lazy var exchangeRateModel = ExchangeRateModel()
    private lazy var converterModel = ConverterModel.shared
    
    weak var delegate: PopUpWindowDelegate?
    
    func configure(with indexPath: IndexPath) {
        var currency = resultDataSource.selectedCurrencies[indexPath.row]
        exchangeRateModel.setExchangeRate(for: &currency)
        currencyButton.setTitle(currency.code, for: .normal)
        currencyButton.tag = (indexPath.row + 1)
        let totalAmount = converterModel.doCalculation(for: currency)
        totalAmountLabel.text = totalAmount.decimalFormat()
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
