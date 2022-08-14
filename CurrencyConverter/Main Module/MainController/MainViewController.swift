//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var mainView: MainView!
    
    private lazy var coreDataStack = CoreDataStack.shared
    
    lazy var initialModel = InitialModel()
    lazy var exchangeRateModel = ExchangeRateModel()
    lazy var dateModel = DateModel()
    
    lazy var resultModel = ResultModel.shared
    lazy var currencyListModel = CurrencyListModel.shared
    
    lazy var resultDataSource = ResultDataSource.shared
    
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
//                coreDataStack.deleteAllEntities()
        
        mainAsyncQueue = AsyncQueue.main
        initialModel.insertCurrencies()
        initialModel.insertGroups()
        setDelegates()
        fillDataSource()
        updateAddButton()
        
        getMonoBankExchangeRate()
        
        //        getPrivatExchangeRate()🥸    
        mainView.lastUpdateDate = dateModel.formattedDate()
    }
    
    private func setDelegates() {
        resultDataSource.controller = self
        ratesWindowView?.popUpWindowDelegate = self
        converterWindowView?.popUpWindowDelegate = self
    }
    
    private func fillDataSource() {
        resultModel.defineTableViewName(value: mainView.isFlipping)
        resultModel.fillDataSource()
    }
    
    private func getMonoBankExchangeRate() {
        guard dateModel.checkLastUpdateDate() else { return }
        guard let url = urlModel.createMonoBankURL() else { return }
        networkService.getMonoBankExchangeRate(url: url) { result, updateDate in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                self.exchangeRateModel.createExchangeRates(monobankData: currencyRates, updateDate)
                self.mainAsyncQueue?.dispatch {
                    self.resultsTableViewReloadData()
                    self.mainView.lastUpdateDate = self.dateModel.formattedDate()
                }
            }
        }
    }
    
    func openCurrencyViewController(sender: UIButton? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: CurrencyListViewController.reuseIdentifier) as? CurrencyListViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        viewController.sender = sender
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
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

extension MainViewController: ResultModelDelegate {
    func resultsTableViewReloadData() {
        fillDataSource()
        updateAddButton()
        mainView.reloadTableViewData()
    }
}
    
extension MainViewController: PopUpWindowDelegate {
    func swipe() {
        mainView.startSwipeAnimation()
        getMonoBankExchangeRate()
    }
    
    func addButtonPressed() {
        openCurrencyViewController()
    }
    
    func rotateButtonPressed() {
        mainView.flipView { /// change the name 🥸
            self.resultsTableViewReloadData()
        }
    }
    
    func updateAddButton() {
        mainView.setAddButtonStatus(resultModel.isMaxNumberOfRows())
    }
    
    func changeCurrency(sender: UIButton) {
        openCurrencyViewController(sender: sender)
    }
}
