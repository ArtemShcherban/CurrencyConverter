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
    var baseCurrency: CurrencyOLD?
    lazy var selectedCurrencies: [CurrencyOLD] = []
   
    private lazy var resultModel = ResultModel.shared
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            return rateCell(for: tableView, at: indexPath)
        case 1:
            return totalAmountCell(for: tableView, at: indexPath)
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
    
    func rateCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RateCell.reuseIdentifier, for: indexPath) as? RateCell else {
            return UITableViewCell()
        }
        cell.delegate = controller
        cell.configure(with: indexPath)
        return cell
    }
    
    func totalAmountCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
        withIdentifier: TotalAmountCell.reuseIdentifier, for: indexPath) as? TotalAmountCell else {
        return UITableViewCell()
        }
        cell.delegate = controller
        cell.configure(with: indexPath)
        return cell
    }
}
