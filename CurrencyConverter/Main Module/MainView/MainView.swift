//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func screenButtonPressed()
}

class MainView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var screenButton: UIButton!
    
//    lazy var ratesWindowView = RatesWindowView()
    lazy var exchangeRatesView = ExchangeRatesView()
    lazy var converterWindowView = ConverterWindowView()
    
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
        containerView.addSubview(exchangeRatesView)
        configureHistoryButton()
        exchangeRatesView.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        containerView.addSubview(exchangeRatesView)
        configureHistoryButton()
        exchangeRatesView.setConstraints()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("MainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func configureHistoryButton() {
        screenButton.layer.cornerRadius = 14
        screenButton.layer.borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        screenButton.layer.borderWidth = 1
    }
    
    func startSwipeAnimation() {
        let centralView = !isFlipping ? exchangeRatesView : converterWindowView
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
            currentTableView = exchangeRatesView.tableView
        }
        currentTableView.reloadData()
    }
    
    func setAddButtonStatus(_ isMaxNumberOfRows: Bool) {
        switch isFlipping {
        case true:
            converterWindowView.addCurrencyButton.isEnabled = !isMaxNumberOfRows
        default:
            exchangeRatesView.addButton.isEnabled = !isMaxNumberOfRows
        }
    }
    
    private func buttonTitleAnimation() {
        screenButton.fadeTransition(1.0)
        screenButton.titleLabel?.text = ""
        let title = isFlipping ? "Currency Converter" : "National Bank Exchange Rate"
        screenButton.setTitle(title, for: .normal)
    }
    
    @IBAction func screenButtonPressed(_ sender: Any) {
        self.buttonTitleAnimation()
        startAnimation {
            self.delegate?.screenButtonPressed()
        }
    }
}
