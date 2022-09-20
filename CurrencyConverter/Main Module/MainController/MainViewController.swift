//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit
import Combine
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var mainView: MainView!
    
    lazy var dateModel = DateModel()
    lazy var networkService = NetworkService()
    private var cancellable: AnyCancellable?
    lazy var exchangeRateModel = ExchangeRateModel.shared
    lazy var ratesDataSource = RatesDataSource.shared
    
    var mainAsyncQueue: Dispatching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        debugPrint(path[0])
        mainAsyncQueue = AsyncQueue.main
        initialSetup {
            self.mainAsyncQueue?.dispatch {
                self.updateCurrentTableView()
            }
        }
        setDelegates()
        setupHideKeyboardTapCesture()
        updateAddButton()
        executeOnFirstStartup()
        exchangeRateModel.removeOldExchangeRates()
        mainView.lastUpdateDate = dateModel.lastUpdateDate()
        getDatafromBank()
    }
    
    private func setDelegates() {
        ratesDataSource.cellDelegate = self
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
            self.mainAsyncQueue?.dispatch {
                self.mainView.updateMessage(error: error)
            }
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

// extension MainViewController: MFMessageComposeViewControllerDelegate {
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        switch result {
//        case .cancelled:
//            dismiss(animated: true)
//        case .sent:
//            let alertController = converterWindowView.createAlertController(with: AlertConstants.messageSent)
//            dismiss(animated: true)
//            present(alertController, animated: true)
//        case .failed:
//            let alertController = converterWindowView.createAlertController(with: AlertConstants.messageFailed)
//            dismiss(animated: true)
//            present(alertController, animated: true)
//        @unknown default:
//            dismiss(animated: true)
//        }
//    }
// }

//    func shareRatesPressed() {
//        CNContactStore().requestAccess(for: .contacts) { success, error in
//            guard success else {
//                print("not authorized error: \(String(describing: error))")
//                return
//            }
//            self.mainAsyncQueue?.dispatch {
//                let contactsViewController = ContactsViewController()
//                self.present(contactsViewController, animated: true)
//            }
//        }
//    }

//    func message(controller: MFMessageComposeViewController) {
//        present(controller, animated: true)
//    }
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//                print(self.view.frame) //🥸
//        print("TextField frame ---- \(converterMainView.popUpWindow.usdTextField.frame)")
//        print("TextField bounds ---- \(converterMainView.popUpWindow.usdTextField.bounds)")
//        print()
//        print()
//        print("SellButton frame ---- \(converterMainView.popUpWindow.sellButton.frame)")
//        print("SellButton bounds ---- \(converterMainView.popUpWindow.sellButton.bounds)")
//        print()
//        print()
//    }
//                coreDataStack.deleteFromCoreData(entityName: "Currency")🥸
//                coreDataStack.deleteFromCoreData(entityName: "CDGroup")
//                        coreDataStack.deleteAllEntities()

//                        let bulletinDataRepo = ExchangeRateDataRepository()
//        bulletinDataRepo.deleteCDExchangeRatesWithNullBulletin()
//        bulletinDataRepo.updateCDBulletinName()
//                        bulletinDataRepo.deleteCDBulletinAndRates(for: Date(timeIntervalSinceReferenceDate: 657932400).startOfDay)
