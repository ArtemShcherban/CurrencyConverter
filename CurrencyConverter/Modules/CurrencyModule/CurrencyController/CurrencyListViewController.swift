//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.07.2022.
//

import UIKit

final class CurrencyListViewController: UIViewController, CurrencyListViewDelegate {
    static let reuseIdentifier = String(describing: CurrencyListViewController.self)
    
    lazy var currencyListModel = CurrencyListModel(coreDataStack: ExchangeService.coreDataStack)
    lazy var currenciesInTableView: [Currency] = []
    lazy var filteredCurrency: [Currency] = []
    lazy var groups: [Group] = []
    private(set) var editingRow: Int?
    private(set) var ratesModel: RatesModel
    
    @IBOutlet weak var tableView: CurrencyListTableView!
    @IBOutlet weak var currensyListView: CurrencyListView!
    
    weak var ratesModelDelegate: RatesModelDelegate?
    
    init?(coder: NSCoder?, ratesModel: RatesModel, editingRow: Int?) {
        self.ratesModel = ratesModel
        self.editingRow = editingRow
        guard let coder = coder else {
            super.init(nibName: nil, bundle: nil)
            return
        }
        super.init(coder: coder)
    }
    
    convenience init?(ratesModel: RatesModel, editingRow: Int?) {
        self.init(coder: nil, ratesModel: ratesModel, editingRow: editingRow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        currensyListView.createView()
        currencyListModel.currenciesForTableView()
        addBackButton()
        setupHideKeyboardTapGesture()
    }
    
    private func setDelegates() {
        currencyListModel.delegate = self
        currensyListView.tableViewDelegate = self
        currensyListView.tableViewDataSource = self
        currensyListView.searchBarDelegate = self
        currensyListView.delegate = self
    }
    
    private func addBackButton() {
        guard let containerName = currencyListModel.containerName else { return }
        let backButton = currensyListView.createBackButton(with: containerName)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension CurrencyListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != String() {
            currencyListModel.filterCurrency(text: searchBar.text ?? String())
            tableView.isFiltered = true
        } else {
            currencyListModel.filterCurrency(text: String())
            tableView.isFiltered = false
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
        tableView.isFiltered = false
        currensyListView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}
