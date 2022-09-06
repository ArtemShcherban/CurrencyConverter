//
//  ExchangeRatesView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 31.08.2022.
//

import UIKit

final class ExchangeRatesView: CentralView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dateTextField: AdjustableTextField!
    @IBOutlet weak var tableView: UITableView!
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
        contentView.fixInView(self)
    }
    
    private func configureTextFild() {
        dateTextField.delegate = self
        dateTextField.text = Date().dMMMyyy
        dateTextField.inputView = datePicker
    }
    
    private func configureTableView() {
        tableView.dataSource = RatesDataSource.shared
        tableView.tag = 0
        tableView.register(
            UINib(nibName: RateCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: RateCell.reuseIdentifier)
    }
    
    @objc func delegatePickerAction(sender: UIDatePicker) {
        dateTextField.text = sender.date.dMMMyyy
        currentDate = sender.date.startOfDay
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        centralViewDelegate?.addButtonPressed()
    }
}

extension ExchangeRatesView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        centralViewDelegate?.dateWasChanged(new: currentDate)
    }
}
