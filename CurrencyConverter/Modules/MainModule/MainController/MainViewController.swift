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
    lazy var selectedCurrencies: [Currency] = []
    lazy var dateModel = DateModel()
    lazy var exchangeRateModel = ExchangeRateModel()
    lazy var ratesModel = RatesModel()
    lazy var converterModel = ConverterModel()
    lazy var messageModel = MessageModel()

    @IBOutlet weak var mainView: MainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainAsyncQueue = AsyncQueue.main
        initialSetup {
            self.mainAsyncQueue?.dispatch {
                self.updateCurrentTableView()
            }
        }
        setDelegates()
        setupHideKeyboardTapGesture()
        updateAddButton()
        executeOnFirstStartup()
        exchangeRateModel.removeOldExchangeRates()
        mainView.lastUpdateDate = dateModel.lastUpdateDate()
        updateData()
    }
    
    private func setDelegates() {
        ratesModel.delegate = self
        converterModel.delegate = self
        messageModel.delegate = self
        mainView.setDelegates(delegate: self)
    }
    
    func fillDataSource() {
        ratesModel.defineContainerName(value: mainView.isRatesView)
        ratesModel.fillDataSource()
    }
    
    func updateData(for date: Date = Date()) {
        guard dateModel.checkTimeInterval(to: date) else { return }
        exchangeRateModel.exchangeRates(for: date) { result in
            switch result {
            case .success(date):
                self.dateModel.renew(updateDate: date)
                self.mainAsyncQueue?.dispatch {
                    self.updateCurrentTableView()
                    self.mainView.lastUpdateDate = self.dateModel.lastUpdateDate()
                }
            default:
                return
            }
        }
    }
    
    func checkUpdateTime(date: Date) -> Bool {
        if dateModel.checkTimeInterval(to: date) {
            return true
        } else {
            let hour = dateModel.nextUpdateHour(from: date)
            mainView.nextUpdateMessage(hour)
            return false
        }
    }
    
    func openCurrencyViewController(for editingRow: Int? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: CurrencyListViewController.reuseIdentifier) as? CurrencyListViewController else { return }
        viewController.ratesModel = ratesModel
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        viewController.editingRow = editingRow
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
