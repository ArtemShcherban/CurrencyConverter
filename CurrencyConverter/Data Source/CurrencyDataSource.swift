//
//  CurrencyDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//

import UIKit

class CurrencyDataSource: NSObject, UITableViewDataSource {
    static let shared = CurrencyDataSource()
    
    lazy var currencyList: [Currency] = []
    lazy var filteredCurrency: [Currency] = []
    lazy var groups: [Group] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.accessibilityIdentifier == "currency" {
            return groups.filter { $0.visible == true }.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.accessibilityIdentifier == "currency" {
            return groups.filter { $0.visible == true }[section].name
        } else if tableView.accessibilityIdentifier == "filtered" {
            return filteredCurrency.isEmpty ? "No items found" : "Search result"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.accessibilityIdentifier == "currency" {
            return currencyList
                .filter { $0.groupKey == groups.filter { $0.visible == true }[section].key }
                .filter { $0.selected == false }.count
        } else if tableView.accessibilityIdentifier == "filtered" {
            return filteredCurrency.count
        }
        return currencyList.filter { $0.selected == true }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell else {
            return UITableViewCell()
        }
        
        if tableView.accessibilityIdentifier == "currency" {
            cell.configure(with: indexPath)
        } else if tableView.accessibilityIdentifier == "filtered" {
            cell.configureWith(indexPath: indexPath)
        }
        return cell
    }
}
