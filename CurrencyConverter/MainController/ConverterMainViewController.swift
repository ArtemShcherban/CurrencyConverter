//
//  ConverterMainViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

class ConverterMainViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var converterMainView: ConverterMainView!
    
    lazy var ratesWindowView = converterMainView.ratesWindowView
    lazy var converterMainModel = ConverterMainModel()
    lazy var currencyModel = CurrencyModel()
    lazy var networkService = NetworkService()
    lazy var urlModel = URLModel()
    
    var mainAsyncQueue: Dispatching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainAsyncQueue = AsyncQueue.main
        currencyModel.createCurrencyGroups()
        getMonoBankExchangeRate()
        getPrivatExchangeRate()
        ratesWindowView?.tableViewDelegate = self
        ratesWindowView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func getMonoBankExchangeRate() {
        guard let url = urlModel.createMonoBankURL() else { return }
        networkService.getMonoBankExchangeRate(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                self.converterMainModel.createExchangeRates(monobankData: currencyRates)
                    self.mainAsyncQueue?.dispatch {
                        self.ratesWindowView?.ratesTableView.reloadData()
                    }
            }
        }
    }
    
    private func getPrivatExchangeRate() {
        guard let url = urlModel.createPrivatBankURL() else { return }
        networkService.getPrivatExchangeRate(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                print(currencyRates)
            }
        }
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

extension ConverterMainViewController: RatesWindowViewDelegate {
    func addButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: CurrenciesViewController.reuseIdentifier)
        viewController.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
