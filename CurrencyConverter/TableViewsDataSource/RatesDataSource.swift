//
//  RatesDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import UIKit

class RatesDataSource: NSObject, UITableViewDataSource {
    static let shared = RatesDataSource()
    
    weak var cellDelegate: MainViewController?
    
    var baseCurrency: Currency?
    lazy var selectedCurrencies: [Currency] = []
    private lazy var ratesModel = RatesModel.shared
    
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
        ratesModel.removeCell(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        cellDelegate?.updateAddButton()
        tableView.reloadData()
    }
    
    private func rateCell(for tableView: UITableView, at indexPath: IndexPath, with currency: Currency) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RateCell.reuseIdentifier, for: indexPath) as? RateCell else {
            return UITableViewCell()
        }
        cell.delegate = cellDelegate
        cell.configureAt(row: indexPath.row, with: currency)
        return cell
    }
    
    private func converterCell(for tableView: UITableView, at indexPath: IndexPath, with currency: Currency) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
        withIdentifier: ConverterCell.reuseIdentifier, for: indexPath) as? ConverterCell else {
        return UITableViewCell()
        }
        cell.delegate = cellDelegate
        let amount = ConverterModel.shared.doCalculation(for: currency)
        cell.configureAt(row: indexPath.row, with: currency, and: amount)
        return cell
    }
}
