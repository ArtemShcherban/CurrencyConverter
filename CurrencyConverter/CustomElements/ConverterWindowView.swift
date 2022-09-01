//
//  PopUpWindow.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.07.2022.
//

import UIKit
protocol InputAmountFieldDeligate: AnyObject { ///////////////////// RENAME
    func amountChanged(in textField: AdjustableTextField)
    func buttonSelected()
}

@IBDesignable
final class ConverterWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var converterTableView: UITableView!
    @IBOutlet weak var addCurrencyButton: UIButton!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var inputAmountField: AdjustableTextField!
    @IBOutlet weak var shareRatesButton: UIButton!
    
    weak var delegate: InputAmountFieldDeligate?
    
    private lazy var resultDataSource = ResultDataSource.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureInputAmountField()
        configureTableView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configureInputAmountField()
        configureTableView()
        configure()
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("ConverterWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    func configureBaseCarrencyButton() {
        guard let currency = resultDataSource.baseCurrency else { return }
        baseCurrencyButton.setTitle(currency.code, for: .normal)
    }
    
    func configureInputAmountField() {
        inputAmountField.delegate = self
        inputAmountField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }
    
    private func configureTableView() {
        converterTableView.dataSource = resultDataSource
        converterTableView.tag = 1
        converterTableView.register(
            UINib(nibName: TotalAmountCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: TotalAmountCell.reuseIdentifier)
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

    
    func createAlertController(with message: (title: String, message: String)) -> UIAlertController {
        let alertController = UIAlertController(
            title: message.title,
            message: message.message,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(alertAction)
        return alertController
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        updateButtonAppearence(sender)
        delegate?.buttonSelected()
    }
    
    @objc func amountChanged(_ sender: AdjustableTextField) {
        delegate?.amountChanged(in: sender)
    }
    
    @IBAction func baseCurrencyPressed(_ sender: UIButton) {
        popUpWindowDelegate?.changeCurrency(sender: sender)
    }
    
    @IBAction func addCurrencyPressed(_ sender: UIButton) {
        popUpWindowDelegate?.addButtonPressed()
    }
    
    @IBAction func arrowButtonPressed(_ sender: Any) {
        popUpWindowDelegate?.rotateButtonPressed()
    }
    @IBAction func shareRatesButtonPressed(_ sender: Any) {
        popUpWindowDelegate?.shareRatesPressed()
    }
}

extension ConverterWindowView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? String()
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 15
    }
}
