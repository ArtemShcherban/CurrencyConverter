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
        addAccessibilityId()
        configureTableView()
        createTableViewShadow()
        searchBar.delegate = searchBarDelegate
    }
    
    func createBackButton() -> UIButton {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.imageView?.contentMode = .scaleToFill
        let title = NSAttributedString(
            string: "Converter",
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
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseIdentifier)
    }
    
    private func addAccessibilityId() {
        tableView.accessibilityIdentifier = "currency"
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
                NSAttributedString.Key.foregroundColor: ColorConstants.darkBlue
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
                NSAttributedString.Key.foregroundColor: ColorConstants.darkBlue
            ])
        content.attributedText = attributedString
        titleView.contentConfiguration = content
    }
}

//extension UITableView {
//    func registerUINibWith(nib name: UITableViewCell.Type) {
//        let nibName = String(describing: name)
//        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
//    }
//
//    func registerCellClassWith(name: UITableViewCell.Type) {
//        let className = String(describing: name)
//        register(name, forCellReuseIdentifier: className)
//    }
//}
