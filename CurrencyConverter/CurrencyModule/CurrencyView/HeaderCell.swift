//
//  HeaderCell.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 25.07.2022.
//

import UIKit

class HeaderCell: UITableViewCell {
    let currencyDataSource = CurrencyDataSource.shared
    
    @IBOutlet weak var sectionTitle: UILabel!
     
    func configure(with section: Int) {
        sectionTitle.text = currencyDataSource.currencyGroups[section].letter
    }
}
