//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func historyButtonPressed()
}

class MainView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    
    lazy var ratesWindowView = RatesWindowView()
    lazy var converterWindowView = ConverterWindowView()
    lazy var historyRateView = HistoryRateView()
    
    lazy var isFlipping = false  // change the name 🥸
    lazy var lastUpdateDate = String() {
        willSet {
            updateDateLabel.text = newValue
        }
    }
    
    weak var delegate: MainViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        containerView.addSubview(ratesWindowView)
        configureHistoryButton()
        ratesWindowView.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        containerView.addSubview(ratesWindowView)
        configureHistoryButton()
        ratesWindowView.setConstraints()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("MainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func configureHistoryButton() {
        historyButton.layer.cornerRadius = 14
        historyButton.layer.borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        historyButton.layer.borderWidth = 1
    }
    
    func startSwipeAnimation() {
        let centralView = !isFlipping ? ratesWindowView : converterWindowView
        centralView.swipeAnimation()
    }
    
    func startAnimation(completion: @escaping(() -> Void)) {
        flipView { // change the name 🥸
            completion()
        }
        titleTransition(
            label: titleLabel,
            title: isFlipping ? TitleConstants.currencyConverter : TitleConstants.exchangeRates,
            direction: isFlipping ? AnimationDirection.back : AnimationDirection.forward)
    }
    
    func reloadTableViewData() {
        var currentTableView: UITableView
        switch isFlipping {
        case true:
            currentTableView = converterWindowView.converterTableView
            converterWindowView.configureBaseCarrencyButton()
        default:
            currentTableView = ratesWindowView.ratesTableView
        }
        currentTableView.reloadData()
    }
    
    func setAddButtonStatus(_ isMaxNumberOfRows: Bool) {
        switch isFlipping {
        case true:
            converterWindowView.addCurrencyButton.isEnabled = !isMaxNumberOfRows
        default:
            ratesWindowView.addButton.isEnabled = !isMaxNumberOfRows
        }
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        containerView.addSubview(historyRateView)
        historyRateView.setConstraints()
        historyRateView.tableView.reloadData()
        delegate?.historyButtonPressed()
    }
}
