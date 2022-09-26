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
final class CurrencyListView: UIView {
    lazy var dataSource = CurrencyListDataSource.shared
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var tableViewDelegate: UITableViewDelegate?
    weak var searchBarDelegate: UISearchBarDelegate?
    weak var delegate: CurrencyListViewDelegate?
    
    func createView() {
        configureTableView()
        createTableViewShadow()
        searchBar.delegate = searchBarDelegate
    }
    
    func createBackButton(with title: String) -> UIButton {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.imageView?.contentMode = .scaleToFill
        let title = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: FontConstants.sfProTextRegular
            ])
        backButton.setAttributedTitle(title, for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDelegateAction), for: .touchUpInside)
        return backButton
    }
    
    @objc private func backButtonDelegateAction() {
        delegate?.backButtonPressed()
    }
    
    private func configureTableView() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = dataSource
        tableView.registerCellClassWith(name: CurrencyCell.self)
    }
    
    private func createTableViewShadow() {
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
                NSAttributedString.Key.font: FontConstants.latoSemiBold,
                NSAttributedString.Key.foregroundColor: ColorConstants.darkBlueDynamic
            ])
        content.attributedText = attributedString
        titleView.contentConfiguration = content
    }
    
    func setHeaderForFiltered(view: UIView, section: Int) {
        guard let titleView = view as? UITableViewHeaderFooterView else { return }
        
        var content = titleView.defaultContentConfiguration()
        let groupName = !dataSource.filteredCurrency.isEmpty ?
        TitleConstants.searchResult : TitleConstants.noCurrencyFound
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        let attributedString = NSAttributedString(
            string: groupName,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: FontConstants.latoSemiBold,
                NSAttributedString.Key.foregroundColor: ColorConstants.darkBlueDynamic
            ])
        content.attributedText = attributedString
        titleView.contentConfiguration = content
    }
}
