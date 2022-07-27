//
//  RatesWindowView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

protocol RatesWindowViewDelegate: AnyObject {
    func addButtonPressed()
}

@IBDesignable
final class RatesWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ratesTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    lazy var tableViewDataSource = CurrencyDataSource.shared
    weak var tableViewDelegate: UITableViewDelegate?
    weak var delegate: RatesWindowViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        tableViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        tableViewSetup()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("RatesWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    func tableViewSetup() {
        ratesTableView.dataSource = tableViewDataSource
        ratesTableView.delegate = tableViewDelegate
        ratesTableView.register(
            UINib(nibName: CurrencyRatesCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: CurrencyRatesCell.reuseIdentifier)
        ratesTableView.accessibilityIdentifier = "rates"
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        delegate?.addButtonPressed()
    }
}
