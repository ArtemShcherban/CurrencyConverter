//
//  CurrencyListView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 04.08.2022.
//

import UIKit

protocol CurrencyListViewDelegate: AnyObject {
    func backButtonPressed()
}

@IBDesignable
class CurrencyListView: UIView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    lazy var searchController = UISearchController()
    lazy var dataSource = CurrencyDataSource.shared
    
    weak var tableViewDelegate: UITableViewDelegate?
    weak var searchResultsDelegate: UISearchResultsUpdating?
    weak var delegate: CurrencyListViewDelegate?
    
    func createView() {
        configureTableView()
        createTableViewShadow()
        configureSearchController()
        addAccessibilityId()
    }
    
    func createBackButton() -> UIButton {
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
        backButton.addTarget(self, action: #selector(backButtonDelegateAction), for: .touchUpInside)
        return backButton
    }
    
    @objc func backButtonDelegateAction() {
        delegate?.backButtonPressed()
    }
    
    func configureTableView() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = dataSource
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseIdentifier)
    }
    
    func createTableViewShadow() {
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 1
    }
    
    func setGroupTitle(view: UIView, section: Int) {
        guard let titleView = view as? UITableViewHeaderFooterView else { return }
        
        var content = titleView.defaultContentConfiguration()
        let groupName = dataSource.groups
            .filter { $0.visible == true }[section].name
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        let attributedString = NSAttributedString(
            string: groupName,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont(name: "Lato-SemiBold", size: 17) ?? UIFont(),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.0, green: 0.191, blue: 0.4, alpha: 1.0)
            ])
        content.attributedText = attributedString
        titleView.contentConfiguration = content
    }
    
    func setHeaderForFiltered(view: UIView, section: Int) {
        guard let titleView = view as? UITableViewHeaderFooterView else { return }
        
        var content = titleView.defaultContentConfiguration()
        let groupName = !dataSource.filteredCurrency.isEmpty ? "Search result:" : "No currency found"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        let attributedString = NSAttributedString(
            string: groupName,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont(name: "Lato-SemiBold", size: 17) ?? UIFont(),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.0, green: 0.191, blue: 0.4, alpha: 1.0)
            ])
        content.attributedText = attributedString
        titleView.contentConfiguration = content
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = searchResultsDelegate
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.searchBarStyle = .minimal
    }
    
    func addAccessibilityId() {
        tableView.accessibilityIdentifier = "currency"
    }
}
