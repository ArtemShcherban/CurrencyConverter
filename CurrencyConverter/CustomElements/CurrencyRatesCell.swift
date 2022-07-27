//
//  CurrencyRatesCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

class CurrencyRatesCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CurrencyRatesCell.self)
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var buyRateLabel: RateTextLabel!
    @IBOutlet weak var sellRateLabel: RateTextLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
