//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.07.2022.
//

import UIKit
import CoreData

class CurrencyListViewController: UIViewController, CurrencyListViewDelegate {
//    static let shared = CurrencyListViewController()
    static let reuseIdentifier = String(describing: CurrencyListViewController.self)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var currensyListView: CurrencyListView!
    
    weak var delegate: RatesTableViewDelegate?
    weak var requestor: UIButton?
    
    private lazy var dataSource = CurrencyDataSource.shared
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var currencyModel = CurrencyModel()
    private lazy var currencyDisplayedModel = CurrencyDisplayedModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        currensyListView.createView()
        addBackButton()
        fillGroups()
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
    
    func fillGroups() {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        let keySortDescriptor = NSSortDescriptor(key: #keyPath(Group.key), ascending: true)
        fetchRequest.sortDescriptors = [keySortDescriptor]
        
        guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else { return }
        dataSource.groups = result
        tableView.reloadData()
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView.accessibilityIdentifier == "currency" {
            currensyListView.setGroupTitle(view: view, section: section)
        } else {
            currensyListView.setHeaderForFiltered(view: view, section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.accessibilityIdentifier == "currency" {
            let currency = currencyModel.selectCurrency(for: indexPath)
            if let requestor = requestor {
                currencyDisplayedModel.changeCurrency(at: requestor.tag, currency: currency)
            } else {
                currencyDisplayedModel.insert(currency: currency)
            }
        } else if tableView.accessibilityIdentifier == "filtered" {
            let currency = currencyModel.selectFilteredCurrency(for: indexPath)
            if let requestor = requestor {
                currencyDisplayedModel.changeCurrency(at: requestor.tag, currency: currency)
            } else {
                currencyDisplayedModel.insert(currency: currency)
            }
            currensyListView.searchController.isActive = false
        }
        coreDataStack.saveContext()
        delegate?.reloadTableView()
        self.dismiss(animated: true)
    }
}

extension CurrencyListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != String() {
            currencyModel.filterCurrency(text: searchController.searchBar.text ?? String())
            currensyListView.tableView.accessibilityIdentifier = "filtered"
        } else {
            currencyModel.filterCurrency(text: String())
            currensyListView.tableView.accessibilityIdentifier = "currency"
        }
        currensyListView.tableView.reloadData()
    }
}
