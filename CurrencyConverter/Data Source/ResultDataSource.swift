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
    lazy var selectedCurrencies: [Currency] = []
   
    private lazy var resultModel = ResultModel.shared
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            return rateCell(for: tableView, at: indexPath)
        case 1:
            if indexPath.row == 0 {
            return inputAmountCell(for: tableView, at: indexPath)
            } else {
                return totalAmountCell(for: tableView, at: indexPath)
            }
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
    
    func inputAmountCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InputAmountCell.reuseIdentifier, for: indexPath) as? InputAmountCell else {
            return UITableViewCell()
        }
        cell.delegate = controller
        cell.inputAmountFieldDelegate = controller
        cell.configure(with: indexPath)
        return cell
    }
    
    func totalAmountCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
//        guard
//            let inputAmountCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InputAmountCell,
//            let text = inputAmountCell.inputAmountField.text,
//            let amount = Double(text) else {
//            return UITableViewCell()
//        }
        
    guard let cell = tableView.dequeueReusableCell(
        withIdentifier: TotalAmountCell.reuseIdentifier, for: indexPath) as? TotalAmountCell else {
        return UITableViewCell()
        }
        cell.delegate = controller
        cell.configure(with: indexPath)
        return cell
    }
}
