//
//  ConverterMainViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

class ConverterMainViewController: UIViewController {
    @IBOutlet weak var converterMainView: ConverterMainView!
    
    lazy var ratesWindowView = converterMainView.ratesWindowView
    lazy var converterMainModel = ConverterMainModel()
    lazy var userDefaultsManager = UserDefaultsManager()
    lazy var currencyModel = CurrencyModel()
    lazy var networkService = NetworkService()
    lazy var urlModel = URLModel()
    lazy var ratesTableView = ratesWindowView?.ratesTableView

    var mainAsyncQueue: Dispatching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainAsyncQueue = AsyncQueue.main
        converterMainModel.delegate = self
        currencyModel.createCurrencyGroups()
        getLastUpdateDate()
        //        converterMainView.ellipsesView.updateDateLabel.text = lastUpdateDate
        
        converterMainModel.getHistoricalData()
        getHistoricalRates()
//                        userDefaultsManager.save(data: "29 Jul 2022 11:17:53")
        getMonoBankExchangeRate()
        //                getPrivatExchangeRate()
        ratesWindowView?.delegate = self
    }
    
    func getHistoricalRates() {
        guard let rates = userDefaultsManager.getData(for: "rates") as? [Int: ExchangeRate] else {
            return
        }
        converterMainModel.fillDataSource(with: rates)
    }

    private func getMonoBankExchangeRate() {
        guard converterMainModel.checkUpdate(time: converterMainView.lastUpdateDate) else { return }
        guard let url = urlModel.createMonoBankURL() else { return }
        networkService.getMonoBankExchangeRate(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                self.userDefaultsManager.save(data: self.networkService.updateDate)
                self.converterMainModel.createExchangeRates(monobankData: currencyRates)
                self.mainAsyncQueue?.dispatch {
                    self.ratesWindowView?.ratesTableView.reloadData()
                    self.converterMainView.lastUpdateDate = self.networkService.updateDate
                }
            }
        }
    }
    
//    private func getPrivatExchangeRate() {
//        guard let url = urlModel.createPrivatBankURL() else { return }
//        networkService.getPrivatExchangeRate(url: url) { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let currencyRates):
//                print(currencyRates)
//            }
//        }
//    }
    
    func getLastUpdateDate() {
        guard let date = userDefaultsManager.getData(for: "Date") as? String else {
            converterMainView.lastUpdateDate = "1 Apr 1976 12:00:00"
            return
        }
        converterMainView.lastUpdateDate = date
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //        print(self.view.frame)
        //        print("TextField frame ---- \(converterMainView.popUpWindow.usdTextField.frame)")
        //        print("TextField bounds ---- \(converterMainView.popUpWindow.usdTextField.bounds)")
        //        print()
        //        print()
        //        print("SellButton frame ---- \(converterMainView.popUpWindow.sellButton.frame)")
        //        print("SellButton bounds ---- \(converterMainView.popUpWindow.sellButton.bounds)")
        //        print()
        //        print()
    }
}

extension ConverterMainViewController: UITableViewDelegate {
}

extension ConverterMainViewController: RatesWindowViewDelegate {
    func addButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: CurrencyListViewController.reuseIdentifier) as? CurrencyListViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}

extension ConverterMainViewController: RatesTableViewDelegate {
    func reloadTableView() {
        guard let tableView = ratesTableView else { return }
        tableView.reloadData()
    }
}
