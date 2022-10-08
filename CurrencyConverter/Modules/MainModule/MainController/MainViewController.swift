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
    lazy var networkService = NetworkService()
    lazy var exchangeRateModel = ExchangeRateModel.shared
    lazy var ratesModel = RatesModel.shared
    lazy var converterModel = ConverterModel.shared
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
        getDatafromBank()
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
    
    func getDatafromBank(for date: Date = Date()) {
        guard dateModel.checkTimeInterval(to: date) else { return }
        networkService.loadData(for: .monoBank) { result in
            self.handleResult(result, date)
            self.networkService.loadData(for: .privatBank(with: date)) { result in
                self.handleResult(result, date)
            }
        }
    }
    
    private func handleResult<BankRate>(_ result: Result<[BankRate], NetworkServiceError>, _ date: Date) {
        switch result {
        case .failure(let error):
            debugPrint(error)
        case .success(let rates):
            let exchangeRates = exchangeRateModel.convertToExchangeRates(bankRates: rates)
            self.exchangeRateModel.updateBulletin(for: date, bankData: exchangeRates)
            self.dateModel.renew(updateDate: date)
            self.mainAsyncQueue?.dispatch {
                self.updateCurrentTableView()
                self.mainView.lastUpdateDate = self.dateModel.lastUpdateDate()
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
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        viewController.editingRow = editingRow
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
