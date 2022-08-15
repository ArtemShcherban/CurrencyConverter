//
//  PopUpWindow.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.07.2022.
//

import UIKit

@IBDesignable
final class ConverterWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var usdTextField: AdjustableTextField!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var converterTableView: UITableView!
    @IBOutlet weak var addCurrencyButton: UIButton!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureTableView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configureTableView()
        configure()
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("ConverterWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    private func configureTableView() {
        converterTableView.dataSource = ResultDataSource.shared
        converterTableView.tag = 1
        converterTableView.register(
            UINib(nibName: ConverterCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: ConverterCell.reuseIdentifier)
    }
    
    private func configure() {
        transform = CGAffineTransform(scaleX: 0.001, y: 1)
    }
    
    @IBAction func addCurrencyPressed(_ sender: UIButton) {
        popUpWindowDelegate?.addButtonPressed()
    }
    
    @IBAction func rotateButtonPressed(_ sender: Any) {
        popUpWindowDelegate?.rotateButtonPressed()
    }
}
