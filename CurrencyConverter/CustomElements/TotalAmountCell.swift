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
    
    weak var delegate: PopUpWindowDelegate?
    
    func configure(with indexPath: IndexPath) {
        exchangeRateModel.setExchangeRate(for: indexPath)
        let currency = resultDataSource.selectedCurrencies[indexPath.row]
        currencyButton.setTitle(currency.code, for: .normal)
        currencyButton.tag = indexPath.row
        totalAmountLabel.text = String(format: "%.2f", currency.totalAmount)
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        print("Button")
        delegate?.changeCurrency(sender: sender)
    }
}
