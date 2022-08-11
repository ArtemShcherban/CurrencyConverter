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

    func configure(with indexPath: IndexPath) {
//        currencyButton.setTitle(String(indexPath.row), for: .normal)
        sumLabel.text = "2345.56"
    }
}
