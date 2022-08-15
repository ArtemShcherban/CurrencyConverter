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
    private lazy var separator: UIView = {
        let separator = UIView(frame: CGRect(x: frame.minX, y: frame.maxY - 6, width: frame.width, height: 1))
        separator.backgroundColor = UIColor.blue
        return separator
    }()

    weak var delegate: PopUpWindowDelegate?
    
    func configure(with indexPath: IndexPath) {
        let currencies = resultDataSource.selectedCurrencies
        currencyButton.setTitle(currencies[indexPath.row].code, for: .normal)
        currencyButton.tag = indexPath.row
        sumLabel.isEnabled = false
        sumLabel.borderWidth = 0
        sumLabel.text = "0.000"
        if indexPath.row == 0 {
            sumLabel.layer.borderWidth = 1
            sumLabel.isEnabled = true
        }
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        delegate?.changeCurrency(sender: sender)
    }
}
