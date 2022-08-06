//
//  RatesWindowView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

protocol RatesWindowViewDelegate: AnyObject {
    func changeCurrency(sender: UIButton)
    func setAddButtonStatus()
    func addButtonPressed()
}

@IBDesignable
final class RatesWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ratesTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    lazy var dataSource = RatesDataSource.shared
    weak var tableViewDelegate: UITableViewDelegate?
    weak var delegate: RatesWindowViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        configureTableView()
        setAccessibilityId()
        checkAddButtonStatus()
    }
    
    private func configure() {
        Bundle.main.loadNibNamed("RatesWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    private  func configureTableView() {
        ratesTableView.dataSource = dataSource
        ratesTableView.delegate = tableViewDelegate
        ratesTableView.register(
            UINib(nibName: CurrencyRatesCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: CurrencyRatesCell.reuseIdentifier)
    }
    
    private  func setAccessibilityId() {
        ratesTableView.accessibilityIdentifier = "rates"
    }
    
    func checkAddButtonStatus() {
        if dataSource.currenciesDisplayed.count <= 4 {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        delegate?.addButtonPressed()
    }
}
