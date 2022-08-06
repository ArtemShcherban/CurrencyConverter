//
//  ExchangeRatesDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

class OLDCurrencyDataSourceOLD: NSObject, UITableViewDataSource {
    static let shared = OLDCurrencyDataSourceOLD()
    
    lazy var ratesBulletin: [ExchangeRate] = []
    
    var rates: [Int: ExchangeRateOLD] = [:]
    var currencies: [CurrencyOLD] = []
    var filteredCurrency: [CurrencyOLD] = []
    var groupedСurrencies: [(letter: String, currencies: [CurrencyOLD])] = []
    var selectedCurrencies: [CurrencyOLD] = []
    lazy var currenciesGroups: [Group] = []
    
//    private lazy var ratesModel = RatesModel()
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        guard let accessibilityID = tableView.accessibilityIdentifier else { return 1 }
//        switch accessibilityID {
//        case "rates":
//            return 1
//        case "currency":
//            return groupedСurrencies.count
//        case "filtered":
//            return 1
//        default:
//            return 0
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let accessibilityID = tableView.accessibilityIdentifier else { return 1 }
        switch accessibilityID {
        case "rates":
            return 1
        case "currency":
            return currenciesGroups.count
        case "filtered":
            return 1
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let accessibilityID = tableView.accessibilityIdentifier else { return nil }
//        switch accessibilityID {
//        case "rates":
//            return nil
//        case "currency":
//            return String(groupedСurrencies[section].letter)
//        case "filtered":
//            return nil
//        default:
//            return nil
//        }
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let accessibilityID = tableView.accessibilityIdentifier else { return nil }
        switch accessibilityID {
        case "rates":
            return nil
        case "currency":
            return currenciesGroups[section].name
        case "filtered":
            return nil
        default:
            return nil
        }
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let accessibilityID = tableView.accessibilityIdentifier else { return 0 }
//        switch accessibilityID {
//        case "rates":
//            return selectedCurrencies.count
//        case "currency":
//            return groupedСurrencies[section].currencies.count
//        case "filtered":
//            return filteredCurrency.count
//        default:
//            return 0
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let accessibilityID = tableView.accessibilityIdentifier else { return 0 }
        switch accessibilityID {
        case "rates":
            return selectedCurrencies.count
        case "currency":
            return 0 //currenciesGroups[section].currencies?.count ?? 0
        case "filtered":
            return filteredCurrency.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let accessibilityID = tableView.accessibilityIdentifier else { return UITableViewCell() }
        switch accessibilityID {
        case "rates":
            guard  let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencyRatesCell.reuseIdentifier,
                for: indexPath) as? CurrencyRatesCell else { return UITableViewCell() }
            cell.configure(with: indexPath)
            return cell
//        case "currency", "filtered":
//            guard let cell = tableView.dequeueReusableCell(
//                withIdentifier: CurrencyCell.reuseIdentifier,
//                for: indexPath) as? CurrencyCell else { return UITableViewCell() }
//            if accessibilityID == "currency" {
//                cell.configure(with: indexPath)
//            } else {
//                cell.configureWith(indexPath: indexPath)
//            }
//            return cell
        default:
            return  UITableViewCell()
        }
    }
}
