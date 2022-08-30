//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.07.2022.
//

import UIKit
import CoreData

class CurrencyListViewController: UIViewController, CurrencyListViewDelegate {
    static let reuseIdentifier = String(describing: CurrencyListViewController.self)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var currensyListView: CurrencyListView!
    
    weak var delegate: ResultModelDelegate?
    weak var sender: UIButton?
    
    private lazy var dataSource = CurrencyDataSource.shared
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var currencyListModel = CurrencyListModel.shared
    private lazy var resultModel = ResultModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        currensyListView.createView()
        currencyListModel.fillDataSourceCurrencies()
        currencyListModel.fillDataSourceGroups()
        addBackButton()
    }
    
    func setDelegates() {
        currensyListView.tableViewDelegate = self
        currensyListView.searchResultsDelegate = self
        currensyListView.delegate = self
    }
    
    func addBackButton() {
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
        
        if let sender = sender {
            resultModel.replaceCurrency(at: sender.tag, with: currency)
        } else {
            resultModel.add(currency: currency)
        }
        
        currensyListView.searchController.isActive = false
        delegate?.resultsTableViewReloadData()
        self.dismiss(animated: true)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var currency: CurrencyOLD
//        switch tableView.accessibilityIdentifier {
//        case "currency":
//            currency = currencyListModel.selectedCurrency(at: indexPath)
//        case "filtered":
//            currency = currencyListModel.selectedFilteredCurrency(at: indexPath)
//        default:
//            return
//        }
//
//        if let sender = sender {
//            resultModel.changeCell(at: sender.tag, with: currency)
//        } else {
//            resultModel.addCell(with: currency)
//        }
//
//        currensyListView.searchController.isActive = false
//        delegate?.resultsTableViewReloadData()
//        self.dismiss(animated: true)
//    }
}

extension CurrencyListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != String() {
            currencyListModel.filterCurrency(text: searchController.searchBar.text ?? String())
            currensyListView.tableView.accessibilityIdentifier = "filtered"
        } else {
            currencyListModel.filterCurrency(text: String())
            currensyListView.tableView.accessibilityIdentifier = "currency"
        }
        currensyListView.tableView.reloadData()
    }
}
