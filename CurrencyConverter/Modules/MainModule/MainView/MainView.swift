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

final class MainView: UIView {
    lazy var isRatesView = true
    lazy var converterView = ConverterView()
    lazy var exchangeRatesView = ExchangeRatesView()
    lazy var lastUpdateDate = String() {
        didSet {
            self.setupLastUpdateLabels()
        }
    }
    let mainAsyncQueue = AsyncQueue.main
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var switchViewButton: UIButton!
    
    weak var delegate: MainViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureSwitchViewButton()
        containerView.addSubview(exchangeRatesView)
        exchangeRatesView.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        configureSwitchViewButton()
        containerView.addSubview(exchangeRatesView)
        exchangeRatesView.setConstraints()
    }
    
    private func configure() {
        Bundle.main.loadNibNamed(AppConstants.mainView, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setDelegates(delegate: MainViewController) {
        self.delegate = delegate
        exchangeRatesView.centralViewDelegate = delegate
        exchangeRatesView.delegate = delegate
        converterView.centralViewDelegate = delegate
        converterView.delegate = delegate
    }
    
    private func configureSwitchViewButton() {
        switchViewButton.layer.cornerRadius = 14
        switchViewButton.layer.borderColor = ColorConstants.lightBlue
        switchViewButton.layer.borderWidth = 1
    }
    
    func startSwipeAnimation(comlition: @escaping () -> Void) {
        let centralView = isRatesView ? exchangeRatesView : converterView
        centralView.swipeAnimation(labelOne: lastUpdatedLabel, labelTwo: updateDateLabel) {
            comlition()
        }
    }
    
    private func startAnimation(completion: @escaping(() -> Void)) {
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
    
    private func setupLastUpdateLabels() {
        self.lastUpdatedLabel.fadeTransition(0.5)
        self.updateDateLabel.fadeTransition(0.5)
        self.lastUpdatedLabel.text = "Last Updated"
        self.updateDateLabel.text = lastUpdateDate
    }
    
    private func workItem(index: Int) -> DispatchWorkItem {
        let guidelines: [String] = MessageConstants.guidelines
        let workItem = DispatchWorkItem {
            self.lastUpdatedLabel.fadeTransition(0.5)
            self.updateDateLabel.fadeTransition(0.5)
            self.updateDateLabel.text = String()
            self.lastUpdatedLabel.text = guidelines[index]
        }
        return workItem
    }
    
    func guidelinesMessage() {
        mainAsyncQueue.dispatchAfter(deadline: .now(), work: workItem(index: 0))
        mainAsyncQueue.dispatchAfter(deadline: .now() + .seconds(3), work: workItem(index: 1))
        mainAsyncQueue.dispatchAfter(deadline: .now() + .seconds(6), work: workItem(index: 2))
        mainAsyncQueue.dispatchAfter(deadline: .now() + .seconds(9), work: workItem(index: 3))
        mainAsyncQueue.dispatchAfter(deadline: .now() + .seconds(12)) {
            self.setupLastUpdateLabels()
        }
    }
    
    func nextUpdateMessage(_ hour: Int?) {
        let message: String
        if let hour = hour {
            let time = hour <= 23 ? "\(hour):00" : "midnight"
            message = "\(MessageConstants.possibleAfter)\(time)."
        } else {
            message = MessageConstants.notPossibleNow
        }
        animateUpdate(message: message)
    }
    
    private func animateUpdate(message: String) {
        lastUpdatedLabel.fadeTransition(0.5)
        updateDateLabel.fadeTransition(0.5)
        lastUpdatedLabel.text = message
        updateDateLabel.text = String()
        let delayInSeconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
            self?.setupLastUpdateLabels()
        }
    }
    
    private func buttonTitleAnimation() {
        switchViewButton.fadeTransition(1.0)
        switchViewButton.titleLabel?.text = ""
        let title = isRatesView ? TitleConstants.exchangeRates : TitleConstants.currencyConverter
        switchViewButton.setTitle(title, for: .normal)
    }
    
    @IBAction func screenButtonPressed(_ sender: Any) {
        self.buttonTitleAnimation()
        startAnimation {
            self.delegate?.switchViewButtonPressed()
        }
    }
}
