//
//  CurrencyListDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//

import UIKit

final class CurrencyListDataSource: NSObject, UITableViewDataSource {
    static let shared = CurrencyListDataSource()
    
    lazy var currencyList: [Currency] = []
    lazy var filteredCurrency: [Currency] = []
    lazy var groups: [Group] = []
    
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
            return currencyList.filter { $0.groupKey == groups[section].key }.count
        }
        return filteredCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cellWith(identifier: CurrencyCell.self, for: indexPath) else {
            return UITableViewCell()
        }
       
        guard
            let tableView = tableView as? CurrencyListTableView,
            tableView.isFiltered else {
            cell.configure(with: indexPath)
            return cell
        }
        cell.configureWith(indexPath: indexPath)
        return cell
    }
}
