//
//  CurrencyListViewController + TableViewDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 07.10.2022.
//

import UIKit

extension CurrencyListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard
            let tableView = tableView as? CurrencyListTableView,
            tableView.isFiltered else {
            return groups.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let tableView = tableView as? CurrencyListTableView,
            tableView.isFiltered else {
            return currenciesInTableView.filter { $0.groupKey == groups[section].key }.count
        }
        return filteredCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cellWith(identifier: CurrencyCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        guard
            let tableView = tableView as? CurrencyListTableView else {
                return cell
            }
        let currency = currency(for: tableView, and: indexPath)
        cell.configure(with: currency)
        return cell
    }
    
    private func currency(for tableView: CurrencyListTableView, and indexPath: IndexPath) -> Currency {
        if tableView.isFiltered {
            return filteredCurrency[indexPath.row]
        }
        let currency = currenciesInTableView
            .filter { $0.groupKey == groups
            .filter { $0.visible == true }[indexPath.section].key
            }[indexPath.row]
        return currency
    }
}
