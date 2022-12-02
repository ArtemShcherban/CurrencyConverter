//
//  CurrencyListViewController + TableViewDelegate.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 07.10.2022.
//

import UIKit

extension CurrencyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        42
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard
            let tableView = tableView as? CurrencyListTableView else {
            return
        }
        let title = currencyListModel.groupTitle(for: section, in: tableView)
        currensyListView.setGroupTitle(forHeader: view, title: title)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var optionalCurrency: Currency?
        if
            let tableView = tableView as? CurrencyListTableView,
            tableView.isFiltered {
            optionalCurrency = currencyListModel.selectedFilteredCurrency(at: indexPath)
        } else {
            optionalCurrency = currencyListModel.selectedCurrency(at: indexPath)
        }
        
        guard let currency = optionalCurrency else { return }
        if let editingRow = editingRow {
            ratesModel?.replaceCurrency(at: editingRow, with: currency)
        } else {
            ratesModel?.add(currency: currency)
        }
        
        ratesModelDelegate?.updateCurrentTableView()
        self.dismiss(animated: true)
    }
}
