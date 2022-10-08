//
//  ExchangeRatesView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 31.08.2022.
//

import UIKit

protocol ExchangeRatesViewDelegate: AnyObject {
    func helpButtonPressed()
}

final class ExchangeRatesView: CentralView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dateTextField: AdjustableTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    lazy var currentDate = Date().startOfDay
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(delegatePickerAction), for: .valueChanged)
        datePicker.minimumDate = Date().oneYearAgo
        datePicker.maximumDate = Date()
        datePicker.frame.size = CGSize(width: 0, height: 200)
        return datePicker
    }()
    
    weak var delegate: ExchangeRatesViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureTextFild()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configureTextFild()
        configureTableView()
    }
    
    private func  configureContentView() {
        Bundle.main.loadNibNamed("ExchangeRatesView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.embedded(in: self)
    }
    
    private func configureTextFild() {
        dateTextField.delegate = self
        dateTextField.text = Date().dMMMyyy
        dateTextField.inputView = datePicker
    }
    
    private func configureTableView() {
        tableView.tag = 0
        tableView.registerUINibWith(nib: RateCell.self)
    }
    
    @objc private func delegatePickerAction(sender: UIDatePicker) {
        dateTextField.text = sender.date.dMMMyyy
        currentDate = sender.date.startOfDay
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        centralViewDelegate?.addButtonPressed()
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        delegate?.helpButtonPressed()
    }
}

extension ExchangeRatesView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        centralViewDelegate?.dateWasChanged(new: currentDate)
    }
}
