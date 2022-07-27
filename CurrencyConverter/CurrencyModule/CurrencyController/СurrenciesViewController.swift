//
//  СurrenciesViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

class CurrenciesViewController: UIViewController, UISearchControllerDelegate {
    static let reuseIdentifier = String(describing: CurrenciesViewController.self)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var currencyDataSource = CurrencyDataSource.shared
    lazy var currencyModel = CurrencyModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        addBackButton()
        searchBar.delegate = self
        currencyDataSource.filteredCurrency = []
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
    
    func tableViewConfigure() {
        tableView.delegate = self
        tableView.dataSource = currencyDataSource
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseIdentifier)
        tableView.accessibilityIdentifier = "currency"
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 1
    }
}

extension CurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currencyGroup = currencyDataSource.currencyGroups[indexPath.section]
        currencyDataSource.selectedCurrencies.append(currencyGroup.currencies[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        print(currencyDataSource.selectedCurrencies.count)
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "HeaderCell") as? HeaderCell else { return UITableViewCell() }
        cell.configure(with: section)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
}

extension CurrenciesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        currencyModel.filterCurrency(text: "")
        tableView.reloadData()
        view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currencyModel.filterCurrency(text: searchText)
        tableView.reloadData()
    }
}
