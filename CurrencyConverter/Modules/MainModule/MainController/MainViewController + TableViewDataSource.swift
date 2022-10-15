//
//  MainViewController + TableViewDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 08.10.2022.
//

import UIKit

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = selectedCurrencies[indexPath.row]
        switch tableView.tag {
        case 0:
            return rateCell(for: tableView, at: indexPath, with: currency)
        case 1:
            return converterCell(for: tableView, at: indexPath, with: currency)
        default :
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        mainModel.rates.removeCell(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        self.updateAddButton()
        tableView.reloadData()
    }
    
    private func rateCell(for tableView: UITableView, at indexPath: IndexPath, with currency: Currency) -> UITableViewCell {
        guard let cell = tableView.cellWith(identifier: RateCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.currencySelectAction = {
            self.openCurrencyViewController(for: indexPath.row)
        }
        cell.configureAt(with: currency)
        return cell
    }
    
    private func converterCell(for tableView: UITableView, at indexPath: IndexPath, with currency: Currency) -> UITableViewCell {
        guard let cell = tableView.cellWith(identifier: ConverterCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.currencyAction = {
            self.openCurrencyViewController(for: indexPath.row + 1)
        }
        let amount = mainModel.converter.doCalculation(for: currency)
        cell.configureAt(with: currency, and: amount)
        return cell
    }
}
