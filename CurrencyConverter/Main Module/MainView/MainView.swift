//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func switchViewButtonPressed()
}

class MainView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var switchViewButton: UIButton!
    
    lazy var exchangeRatesView = ExchangeRatesView()
    lazy var converterView = ConverterView()
    
    lazy var isRatesView = true
    lazy var lastUpdateDate = String() {
        willSet {
            updateDateLabel.text = newValue
        }
    }
    
    weak var delegate: MainViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureHistoryButton()
        containerView.addSubview(exchangeRatesView)
        exchangeRatesView.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        configureHistoryButton()
        containerView.addSubview(exchangeRatesView)
        exchangeRatesView.setConstraints()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("MainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setDelegates(delegate: MainViewController) {
        self.delegate = delegate
        exchangeRatesView.centralViewDelegate = delegate
        converterView.centralViewDelegate = delegate
        converterView.delegate = delegate
    }
    
    func configureHistoryButton() {
        switchViewButton.layer.cornerRadius = 14
        switchViewButton.layer.borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        switchViewButton.layer.borderWidth = 1
    }
    
    func startSwipeAnimation() {
        let centralView = isRatesView ? exchangeRatesView : converterView
        centralView.swipeAnimation()
    }
    
    func startAnimation(completion: @escaping(() -> Void)) {
        animateSwitchView {
            completion()
        }
        titleTransition(
            label: titleLabel,
            title: isRatesView ? TitleConstants.exchangeRates : TitleConstants.currencyConverter,
            direction: isRatesView ? AnimationDirection.back : AnimationDirection.forward)
    }
    
    func updateTableView() {
        var currentTableView: UITableView
        switch isRatesView {
        case true:
            currentTableView = exchangeRatesView.tableView
        default:
            currentTableView = converterView.tableView
            converterView.configureBaseCarrencyButton()
        }
        currentTableView.reloadData()
    }
    
    func setAddButtonStatus(_ isMaxNumberOfRows: Bool) {
        switch isRatesView {
        case true:
            exchangeRatesView.addButton.isEnabled = isMaxNumberOfRows
        default:
            converterView.addButton.isEnabled = isMaxNumberOfRows
        }
    }
    
    private func buttonTitleAnimation() {
        switchViewButton.fadeTransition(1.0)
        switchViewButton.titleLabel?.text = ""
        let title = isRatesView ? "National Bank Exchange Rate" : "Currency Converter"
        switchViewButton.setTitle(title, for: .normal)
    }
    
    @IBAction func screenButtonPressed(_ sender: Any) {
        self.buttonTitleAnimation()
        startAnimation {
            self.delegate?.switchViewButtonPressed()
        }
    }
}
