//
//  RatesWindowView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

@IBDesignable
final class RatesWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ratesTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    
    lazy var dataSource = ResultDataSource.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configureTableView()
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("RatesWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    private func configureTableView() {
        ratesTableView.dataSource = dataSource
        ratesTableView.tag = 0
        ratesTableView.register(
            UINib(nibName: RateCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: RateCell.reuseIdentifier)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        popUpWindowDelegate?.addButtonPressed()
    }
    
    @IBAction func rotateButtonPressed(_ sender: Any) {
        popUpWindowDelegate?.rotateButtonPressed()
    }
}
