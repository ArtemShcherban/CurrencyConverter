//
//  PopUpWindow.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.07.2022.
//

import UIKit
protocol ConverterViewDelegate: AnyObject {
    func valueChanged(in textField: inout AdjustableTextField)
    func sellBuyButtonTapped()
}

@IBDesignable
final class ConverterView: CentralView {
    private lazy var mainDataSource = MainDataSource.shared
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var inputAmountTextField: AdjustableTextField!
    @IBOutlet weak var shareRatesButton: UIButton!
    
    weak var delegate: ConverterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureInputAmountField()
        configureTableView()
        transform = CGAffineTransform(scaleX: 0.001, y: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configureInputAmountField()
        configureTableView()
        transform = CGAffineTransform(scaleX: 0.001, y: 1)
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("ConverterView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.embedded(in: self)
    }
    
    func configureBaseCarrencyButton() {
        guard let currency = mainDataSource.baseCurrency else { return }
        baseCurrencyButton.setTitle(currency.code, for: .normal)
    }
    
    private func configureInputAmountField() {
        inputAmountTextField.delegate = self
        inputAmountTextField.addTarget(self, action: #selector(valueChangedInTextField), for: .editingChanged)
    }
    
    private func configureTableView() {
        tableView.dataSource = mainDataSource
        tableView.tag = 1
        tableView.registerUINibWith(nib: ConverterCell.self)
    }
    
    private func updateButtonsAppearence(_ selectedButton: UIButton) {
        guard
            let deselectedButton = selectedButton == sellButton ? buyButton : sellButton else {
            return
        }
        selectedButton.isSelected = true
        selectedButton.isEnabled = false
        selectedButton.backgroundColor = selectedButton.tintColor
        
        deselectedButton.isSelected = false
        deselectedButton.isEnabled = true
        deselectedButton.backgroundColor = ColorConstants.whiteBackgroundDynamic
    }
    
    @IBAction func actionTypeButtonChanged(_ sender: UIButton) {
        updateButtonsAppearence(sender)
        delegate?.sellBuyButtonTapped()
    }
    
    @objc private func valueChangedInTextField() {
        delegate?.valueChanged(in: &inputAmountTextField)
    }
    
    @IBAction func baseCurrencyPressed(_ sender: UIButton) {
        centralViewDelegate?.changeCurrency(at: 0)
    }
    
    @IBAction func addCurrencyPressed(_ sender: UIButton) {
        centralViewDelegate?.addButtonPressed()
    }
    
    @IBAction func shareRatesButtonPressed(_ sender: UIButton) {
        centralViewDelegate?.shareRates(sender: sender)
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
