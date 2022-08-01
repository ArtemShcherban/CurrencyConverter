//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.07.2022.
//

import UIKit

class CurrencyListViewController: UIViewController {
    static let reuseIdentifier = String(describing: CurrencyListViewController.self)
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: RatesTableViewDelegate?
    
    private lazy var dataSource = CurrencyDataSource.shared
    private lazy var searchController = UISearchController()
    private lazy var currencyModel = CurrencyModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
        addBackButton()
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.imageView?.contentMode = .scaleToFill
        let title = NSAttributedString(
            string: "Converter",
            attributes: [
                NSAttributedString.Key.font:
                    UIFont(
                        name: "SFProText-Regular",
                        size: 17) ?? UIFont()
            ])
        backButton.setAttributedTitle(title, for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseIdentifier)
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 1
        tableView.accessibilityIdentifier = "currency"
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.searchBarStyle = .minimal
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell else {
            return UIView()
        }
        if tableView.accessibilityIdentifier == "currency" {
        cell.configure(with: section)
        } else {
            cell.configureWith(section: section)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accessibilityID = tableView.accessibilityIdentifier
        switch accessibilityID {
        case "filtered":
            currencyModel.updateSelectedCurrencies(indexPath: indexPath, isBeingFiltered: true)
            currencyModel.deleteFromCurrencyList(indexPath: indexPath, isBeingFiltered: true)
            searchController.isActive = false
        default :
            currencyModel.updateSelectedCurrencies(indexPath: indexPath, isBeingFiltered: false)
            currencyModel.deleteFromCurrencyList(indexPath: indexPath, isBeingFiltered: false)
        }
        delegate?.reloadTableView()
        self.dismiss(animated: true)
    }
}

extension CurrencyListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != String() {
            currencyModel.filterCurrency(text: searchController.searchBar.text ?? String())
            tableView.accessibilityIdentifier = "filtered"
        } else {
            currencyModel.filterCurrency(text: "")
            tableView.accessibilityIdentifier = "currency"
        }
        tableView.reloadData()
    }
}
