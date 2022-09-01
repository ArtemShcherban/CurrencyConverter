//
//  HistoryRateView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 31.08.2022.
//

import UIKit

protocol HistoryRateViewDelegate: AnyObject {
    func pickerAction(sender: UIDatePicker)
}

final class HistoryRateView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dateTextField: AdjustableTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var arrowButton: UIButton!
    
//    private lazy var dateModel = DateModel()
    
    lazy var datePicker: UIDatePicker = {
             let datePicker = UIDatePicker()
             datePicker.date = Date()
             datePicker.datePickerMode = .date
             datePicker.preferredDatePickerStyle = .wheels
             datePicker.addTarget(self, action: #selector(delegatePickerAction), for: .valueChanged)
             datePicker.maximumDate = Date()
             datePicker.frame.size = CGSize(width: 0, height: 200)
             return datePicker
    }()
    
    weak var delegate: HistoryRateViewDelegate?
    
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
        Bundle.main.loadNibNamed("HistoryRateView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    private func configureTextFild() {
//        dateTextField.text = getDateAsString(from: Date())
        dateTextField.inputView = datePicker
    }
    
    private func configureTableView() {
        tableView.dataSource = ResultDataSource.shared
        tableView.tag = 2
        tableView.register(
            UINib(nibName: RateCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: RateCell.reuseIdentifier)
    }
    
//   private func createDatePicker() -> UIDatePicker {
//        let datePicker = UIDatePicker()
//        datePicker.date = Date()
//        datePicker.datePickerMode = .date
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.addTarget(self, action: #selector(delegatePickerAction), for: .valueChanged)
//        datePicker.minimumDate = dateModel.minimumDate()
//        datePicker.maximumDate = Date()
//        datePicker.frame.size = CGSize(width: 0, height: 200)
//        return datePicker
//    }
    
//    private func getDateAsString(from date: Date) -> String {
//        let format = "d MMM yyy"
//        return dateModel.formattedDate(date: date, format: format)
//    }
    
    @objc func delegatePickerAction(sender: UIDatePicker) {
//        dateTextField.text = getDateAsString(from: sender.date)
        delegate?.pickerAction(sender: sender)
    }
    
    @IBAction func arrowButtonPressed(_ sender: Any) {
        removeFromSuperview()
    }
}
