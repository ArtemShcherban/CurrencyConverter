//
//  ResultDataSource.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import UIKit

class ResultDataSource: NSObject, UITableViewDataSource {
    static let shared = ResultDataSource()
    
    var controller: MainViewController?
    
    var baseCurrency: Currency?
    lazy var selectedCurrencies: [Currency] = []
    private lazy var resultModel = ResultModel.shared
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = selectedCurrencies[indexPath.row]
        switch tableView.tag {
        case 0:
            return rateCell(for: tableView, at: indexPath, with: currency)
        case 1:
            return totalAmountCell(for: tableView, at: indexPath, with: currency)
        default :
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        resultModel.removeCell(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        controller?.updateAddButton()
        tableView.reloadData()
    }
    
    private func rateCell(for tableView: UITableView, at indexPath: IndexPath, with currency: Currency) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RateCell.reuseIdentifier, for: indexPath) as? RateCell else {
            return UITableViewCell()
        }
        cell.delegate = controller
        cell.configureAt(row: indexPath.row, with: currency)
        return cell
    }
    
    private func totalAmountCell(for tableView: UITableView, at indexPath: IndexPath, with currency: Currency) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
        withIdentifier: TotalAmountCell.reuseIdentifier, for: indexPath) as? TotalAmountCell else {
        return UITableViewCell()
        }
        cell.delegate = controller
        let amount = ConverterModel.shared.doCalculation(for: currency)
        cell.configureAt(row: indexPath.row, with: currency, and: amount)
        return cell
    }
}
