//
//  RatesDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import UIKit

class RatesDataSource: NSObject, UITableViewDataSource {
    static let shared = RatesDataSource()
    
    var controller: MainViewController?
    
    private lazy var currencyDisplayedModel = CurrencyDisplayedModel()
    lazy var currenciesDisplayed: [Currency] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currenciesDisplayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyRatesCell.reuseIdentifier, for: indexPath) as? CurrencyRatesCell else {
            return UITableViewCell()
        }
        cell.delegate = controller
        cell.configure(with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        currencyDisplayedModel.removeCurrency(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        controller?.setAddButtonStatus()
    }
}
