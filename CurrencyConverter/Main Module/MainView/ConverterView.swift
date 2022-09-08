//
//  PopUpWindow.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.07.2022.
//

import UIKit
protocol ConverterViewDelegate: AnyObject { ///////////////////// RENAME
    func valueChanged(in textField: inout AdjustableTextField)
    func buttonSelected()
}

@IBDesignable
final class ConverterView: CentralView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var textField: AdjustableTextField!
    @IBOutlet weak var shareRatesButton: UIButton!
    
    weak var delegate: ConverterViewDelegate?
    
    private lazy var ratesDataSource = RatesDataSource.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureInputAmountField()
        configureTableView()
        configure()
        addButton.setupConstraints()
        addButton.activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configureInputAmountField()
        configureTableView()
        configure()
        addButton.setupConstraints()
        addButton.activateConstraints()
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("ConverterView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    func configureBaseCarrencyButton() {
        guard let currency = ratesDataSource.baseCurrency else { return } // ??remove to MainViewController?? 🥸
        baseCurrencyButton.setTitle(currency.code, for: .normal)
    }
    
    func configureInputAmountField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(valueChangedInTextField), for: .editingChanged)
    }
    
    private func configureTableView() {
        tableView.dataSource = ratesDataSource
        tableView.tag = 1
        tableView.register(
            UINib(nibName: ConverterCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: ConverterCell.reuseIdentifier)
    }
    
    private func configure() {
        transform = CGAffineTransform(scaleX: 0.001, y: 1)
    }
    
    private func updateButtonAppearence(_ selectedButton: UIButton) {
        guard
            let deselectedButton = selectedButton == sellButton ? buyButton : sellButton else {
            return
        }
        selectedButton.isSelected = true
        selectedButton.isEnabled = false
        selectedButton.backgroundColor = selectedButton.tintColor
        
        deselectedButton.isSelected = false
        deselectedButton.isEnabled = true
        deselectedButton.backgroundColor = .white
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        updateButtonAppearence(sender)
        delegate?.buttonSelected()
    }
    
    @objc func valueChangedInTextField() {
        delegate?.valueChanged(in: &textField)
    }
    
    @IBAction func baseCurrencyPressed(_ sender: UIButton) {
        centralViewDelegate?.changeCurrency(at: 0)
    }
    
    @IBAction func addCurrencyPressed(_ sender: UIButton) {
        centralViewDelegate?.addButtonPressed()
    }
    
    @IBAction func shareRatesButtonPressed(_ sender: Any) {
        centralViewDelegate?.shareRatesPressed()
    }
}

extension ConverterView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? String()
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 15
    }
}
