//
//  ExchangeRatesDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

class CurrencyDataSource: NSObject, UITableViewDataSource {
    static let shared = CurrencyDataSource()
    
    var rates: [Int: ExchangeRate] = [:]
    var selectedCurrencies: [Currency] = []
    var currencyGroups: [(letter: String, currencies: [Currency])] = []
    var filteredCurrency: [Currency] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.accessibilityIdentifier == "rates" {
            return 1
        } else {
            if filteredCurrency.isEmpty {
            return currencyGroups.count
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.accessibilityIdentifier == "rates" {
            return nil
        } else {
            if filteredCurrency.isEmpty {
            return String(currencyGroups[section].letter)
            } else {
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.accessibilityIdentifier == "rates" {
            return selectedCurrencies.count
        } else {
            if filteredCurrency.isEmpty {
            return currencyGroups[section].currencies.count
            } else {
                return filteredCurrency.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.accessibilityIdentifier == "rates" {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencyRatesCell.reuseIdentifier,
                for: indexPath) as? CurrencyRatesCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencyCell.reuseIdentifier,
                for: indexPath) as? CurrencyCell else {
                return UITableViewCell()
            }
            if filteredCurrency.isEmpty {
                cell.configure(with: indexPath)
            } else {
                cell.configureWith(indexPath: indexPath)
            }
            return cell
        }
    }
}
