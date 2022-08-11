//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController, PopUpWindowDelegate {
    @IBOutlet weak var mainView: MainView!
    
    lazy var ratesDataSource = RatesDataSource.shared
    
    lazy var initialModel = InitialModel()
    lazy var ratesModel = RatesModel()
    lazy var dateModel = DateModel()
    
    lazy var currencyModel = CurrencyModel()
    lazy var currencyDisplayedModel = CurrencyDisplayedModel()
    
    lazy var networkService = NetworkService()
    lazy var urlModel = URLModel()
    
    lazy var ratesWindowView = mainView.ratesWindowView
    lazy var ratesTableView = ratesWindowView?.ratesTableView
    lazy var converterWindowView = mainView.converterWindowView
    
    var mainAsyncQueue: Dispatching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        coreDataStack.deleteFromCoreData(entityName: "Currency")🥸
        //        coreDataStack.deleteFromCoreData(entityName: "Group")
        //        coreDataStack.deleteAllEntities()
        
        mainAsyncQueue = AsyncQueue.main
        
        initialModel.insertCurrencies()
        initialModel.insertGroups()
        currencyDisplayedModel.fillRatesDataSource()
        setDelegates()
        setAddButtonStatus()
        
        getMonoBankExchangeRate()
        
        //        getPrivatExchangeRate()🥸    
        mainView.lastUpdateDate = dateModel.formattedDate()
    }
    
    func setDelegates() {
        ratesDataSource.controller = self
        ratesWindowView?.popUpWindowDelegate = self
        converterWindowView?.popUpWindowDelegate = self
        ratesWindowView?.delegate = self
    }
    
    private func getMonoBankExchangeRate() {
        guard dateModel.checkLastUpdateDate() else { return }
        guard let url = urlModel.createMonoBankURL() else { return }
        networkService.getMonoBankExchangeRate(url: url) { result, updateDate in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                self.ratesModel.createExchangeRates(monobankData: currencyRates, updateDate)
                self.mainAsyncQueue?.dispatch {
                    self.reloadTableView()
                    self.mainView.lastUpdateDate = self.dateModel.formattedDate()
                }
            }
        }
    }
    
    func swipe() {
        mainView.startSwipeAnimation()
        getMonoBankExchangeRate()
    }
    
    //    private func getPrivatExchangeRate() {🥸
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //        print(self.view.frame)🥸
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

extension MainViewController: RatesWindowViewDelegate {
    func setAddButtonStatus() {
        ratesWindowView?.checkAddButtonStatus()
    }
    
    func changeCurrency(sender: UIButton) {
        openCurrencyViewController(requestor: sender)
    }
    
    func addButtonPressed() {
        openCurrencyViewController()
    }
    
    func rotateButtonPressed() {
        mainView.flipView()       /// change the name 🥸
    }
    
    func openCurrencyViewController(requestor: UIButton? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: CurrencyListViewController.reuseIdentifier) as? CurrencyListViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        viewController.requestor = requestor
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}

extension MainViewController: RatesTableViewDelegate {
    func reloadTableView() {
        guard let tableView = ratesTableView else { return }
        ratesWindowView?.checkAddButtonStatus()
        tableView.reloadData()
    }
}
