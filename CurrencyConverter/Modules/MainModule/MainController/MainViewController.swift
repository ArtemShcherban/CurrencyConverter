//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

final class MainViewController: UIViewController {
    var mainAsyncQueue: Dispatching?
    var baseCurrency: Currency?
    lazy var groups: [Group] = []
    lazy var currenciesList: [Currency] = []
    lazy var selectedCurrencies: [Currency] = []
    lazy var exchangeService = ExchangeService()
    lazy var isRatesView = true
    lazy var converterView = ConverterView()
    lazy var exchangeRatesView = ExchangeRatesView()
    lazy var lastUpdateDate = String() {
        didSet {
            self.setupLastUpdateLabels()
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var switchViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainAsyncQueue = AsyncQueue.main
        initialSetup {
            self.mainAsyncQueue?.dispatch {
                self.updateCurrentTableView()
            }
        }
        configureView()
        setDelegates()
        setupHideKeyboardTapGesture()
        updateAddButton()
        executeOnFirstStartup()
        exchangeService.exchangeRateModel.removeOldExchangeRates()
        lastUpdateDate = exchangeService.dateModel.lastUpdateDate()
        updateData()
    }
    
    private func configureView() {
        configureSwitchViewButton()
        containerView.addSubview(exchangeRatesView)
        exchangeRatesView.setConstraints()
    }
    
    private func setDelegates() {
        exchangeService.ratesModel.delegate = self
        exchangeService.converterModel.delegate = self
        exchangeService.messageModel.delegate = self
        exchangeRatesView.centralViewDelegate = self
        exchangeRatesView.delegate = self
        exchangeRatesView.tableView.dataSource = self
        converterView.centralViewDelegate = self
        converterView.delegate = self
        converterView.tableView.dataSource = self
    }
    
    func fillDataSource() {
        exchangeService.ratesModel.defineContainerName(value: isRatesView)
        exchangeService.ratesModel.fillSelectedCurrencies()
    }
    
    func updateData(for date: Date = Date()) {
        guard exchangeService.dateModel.checkTimeInterval(to: date) else { return }
        exchangeService.exchangeRateModel.exchangeRates(for: date) { result in
            switch result {
            case .success(date):
                self.exchangeService.dateModel.renew(updateDate: date)
                self.mainAsyncQueue?.dispatch {
                    self.updateCurrentTableView()
                    self.lastUpdateDate = self.exchangeService.dateModel.lastUpdateDate()
                }
            default:
                return
            }
        }
    }
    
    func checkUpdateTime(date: Date) -> Bool {
        if exchangeService.dateModel.checkTimeInterval(to: date) {
            return true
        } else {
            let hour = exchangeService.dateModel.nextUpdateHour(from: date)
            nextUpdateMessage(hour)
            return false
        }
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
    
    func openCurrencyViewController(for editingRow: Int? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController =
        storyboard.instantiateViewController(
            identifier: CurrencyListViewController.reuseIdentifier) { coder -> CurrencyListViewController? in
            CurrencyListViewController(
                coder: coder,
                ratesModel: self.exchangeService.ratesModel,
                editingRow: editingRow
            )
        }

        viewController.modalPresentationStyle = .fullScreen
        viewController.ratesModelDelegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    private func configureSwitchViewButton() {
        switchViewButton.layer.cornerRadius = 14
        switchViewButton.layer.borderColor = ColorConstants.lightBlue
        switchViewButton.layer.borderWidth = 1
    }
    
    private func nextUpdateMessage(_ hour: Int?) {
        let message: String
        if let hour = hour {
            let time = hour <= 23 ? "\(hour):00" : "midnight"
            message = "\(MessageConstants.possibleAfter)\(time)."
        } else {
            message = MessageConstants.notPossibleNow
        }
        animateUpdate(message: message)
    }
    
    func guidelinesMessage(completion: @escaping () -> Void) {
        let guidelines: [String] = MessageConstants.guidelines
        var index = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.lastUpdatedLabel.fadeTransition(0.5)
            self.updateDateLabel.fadeTransition(0.5)
            self.updateDateLabel.text = String()
            self.lastUpdatedLabel.text = guidelines[index]
            index += 1
            if index == guidelines.count {
                timer.invalidate()
                self.setupLastUpdateLabels()
                completion()
            }
        }
        timer.fire()
    }
    
    func setAddButtonStatus(_ isMaxNumberOfRows: Bool) {
        switch isRatesView {
        case true:
            exchangeRatesView.addButton.isEnabled = isMaxNumberOfRows
        default:
            converterView.addButton.isEnabled = isMaxNumberOfRows
        }
    }
    
    @IBAction func screenButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        self.titleAnimation(for: sender)
        startAnimationForView(and: titleLabel) {
            self.switchViewButtonTapped()
            sender.isEnabled = true
        }
    }
}
