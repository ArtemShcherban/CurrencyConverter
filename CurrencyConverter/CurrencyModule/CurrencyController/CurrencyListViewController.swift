//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.07.2022.
//

import UIKit

final class CurrencyListViewController: UIViewController, CurrencyListViewDelegate {
    static let reuseIdentifier = String(describing: CurrencyListViewController.self)
    private lazy var dataSource = CurrencyListDataSource.shared
    private lazy var currencyListModel = CurrencyListModel.shared
    private lazy var ratesModel = RatesModel.shared
    var editingRow: Int?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var currensyListView: CurrencyListView!
    
    weak var delegate: RatesModelDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        currensyListView.createView()
        currencyListModel.fillCurrencyDataSource()
        addBackButton()
        setupHideKeyboardTapCesture()
    }
    
    private func setDelegates() {
        currensyListView.tableViewDelegate = self
        currensyListView.searchBarDelegate = self
        currensyListView.delegate = self
    }
    
    private func addBackButton() {
        let backButton = currensyListView.createBackButton()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func backButtonPressed() {
        dismiss(animated: true)
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch tableView.accessibilityIdentifier {
        case "filtered":
            currensyListView.setHeaderForFiltered(view: view, section: section)
        default:
            currensyListView.setGroupTitle(view: view, section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currency: Currency
        switch tableView.accessibilityIdentifier {
        case "currency":
            currency = currencyListModel.selectedCurrency(at: indexPath)
        case "filtered":
            currency = currencyListModel.selectedFilteredCurrency(at: indexPath)
        default:
            return
        }
        
        if let editingRow = editingRow {
            ratesModel.replaceCurrency(at: editingRow, with: currency)
        } else {
            ratesModel.add(currency: currency)
        }
        
        delegate?.updateCurrentTableView()
        self.dismiss(animated: true)
    }
}

extension CurrencyListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != String() {
            currencyListModel.filterCurrency(text: searchBar.text ?? String())
            currensyListView.tableView.accessibilityIdentifier = "filtered"
        } else {
            currencyListModel.filterCurrency(text: String())
            currensyListView.tableView.accessibilityIdentifier = "currency"
        }
        currensyListView.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        currensyListView.tableView.accessibilityIdentifier = "currency"
        currensyListView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}
