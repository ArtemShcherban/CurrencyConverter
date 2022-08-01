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
        sectionTitle.text = currencyDataSource.groupedСurrencies[section].letter
    }
    
    func configureWith(section: Int) {
        sectionTitle.text = currencyDataSource.filteredCurrency.isEmpty ? "Items not found" :
        "Search result:"
    }
}
