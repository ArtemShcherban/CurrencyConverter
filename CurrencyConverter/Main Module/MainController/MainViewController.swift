//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit
import CoreData
import Contacts
import ContactsUI
import MessageUI

class MainViewController: UIViewController { // MessageModelDelegate {
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
    lazy var converterWindowView = mainView.converterWindowView
    lazy var historyRateView = mainView.historyRateView
    
    lazy var converterModel = ConverterModel.shared
    lazy var historicalRateModel = HistoryRateModel()
    
    lazy var messageModel = MessageModel.shared
    
    var mainAsyncQueue: Dispatching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        debugPrint(path[0])
//                coreDataStack.deleteFromCoreData(entityName: "Currency")🥸
//                coreDataStack.deleteFromCoreData(entityName: "CDGroup")
//                coreDataStack.deleteAllEntities()
        
        mainAsyncQueue = AsyncQueue.main
        initialModel.insertCurrencies()
        initialModel.insertGroups()
        initialModel.createCurrencyContainers()
        initialModel.updateContainerWithBaseCurrency()
        setDelegates()
        fillDataSource()
        updateAddButton()
        
        getMonoBankExchangeRate()
        
        //        getPrivatExchangeRate()🥸
        mainView.lastUpdateDate = dateModel.lastUpdateDate()
        setupHideKeyboardTapCesture()
    }
    
    private func setDelegates() {
        resultDataSource.controller = self
        ratesWindowView.popUpWindowDelegate = self
        converterWindowView.popUpWindowDelegate = self
        converterWindowView.delegate = self
//        messageModel.delegate = self
        mainView.delegate = self
        historyRateView.delegate = self
    }
    
    private func fillDataSource() {
        resultModel.defineContainerName(value: mainView.isFlipping)
        resultModel.fillDataSource()
    }
    
    private func getMonoBankExchangeRate() {
        guard dateModel.checkTimeInterval() else { return }
        guard let url = urlModel.createMonoBankURL() else { return }
        networkService.getMonoBankExchangeRate(url: url) { result, updateDate in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                self.exchangeRateModel.createExchangeRate(bankData: currencyRates)
                self.dateModel.received(new: updateDate)
                self.mainAsyncQueue?.dispatch {
                    self.resultsTableViewReloadData()
                    self.mainView.lastUpdateDate = self.dateModel.lastUpdateDate()
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
        //                print(self.view.frame) //🥸
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

extension MainViewController: MainViewDelegate {
    func historyButtonPressed() {
        historyRateView.datePicker.minimumDate = dateModel.minimumDate()
        historyRateView.dateTextField.text = dateModel.formattedDate(date: Date(), format: "d MMM yyyy")
    }
}

extension MainViewController: HistoryRateViewDelegate {
    func pickerAction(sender: UIDatePicker) {
        let date = sender.date
        historyRateView.dateTextField.text = dateModel.formattedDate(date: sender.date, format: "d MMM yyyy")
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] timer in
            guard self.dateModel.checkPickerDate(sender.date) else { return }
            if let historicalRates = self.historicalRateModel.getHistoricalRates(for: date) {}
            guard let url = urlModel.createNationalBankURL(with: dateModel.formattedDate(date: date, format: "dd.MM.YYYY")) else { return }
            networkService.getNationalBankHistoricalRates(url: url)
        }

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
        mainView.startAnimation {
            self.resultsTableViewReloadData()
        }
    }
    
    func updateAddButton() {
        mainView.setAddButtonStatus(resultModel.isMaxNumberOfRows())
    }
    
    func changeCurrency(sender: UIButton) {
        openCurrencyViewController(sender: sender)
    }
    
    func shareRatesPressed() {
        let text = messageModel.createMessage()
        let textToShare = [text]
        let activityController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.popoverPresentationController?.permittedArrowDirections = .any
        present(activityController, animated: true, completion: nil)
    }
    
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
}

extension MainViewController: InputAmountFieldDeligate {
    func buttonSelected() {
        converterModel.isSellAction.toggle()
        resultsTableViewReloadData()
    }
    
    func amountChanged(in textField: AdjustableTextField) {
        converterWindowView.inputAmountField.text = converterModel.transform(textField.text)
        resultsTableViewReloadData()
    }
}

extension MainViewController {
    func setupHideKeyboardTapCesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MainViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            dismiss(animated: true)
        case .sent:
            let alertController = converterWindowView.createAlertController(with: AlertConstants.messageSent)
            dismiss(animated: true)
            present(alertController, animated: true)
        case .failed:
            let alertController = converterWindowView.createAlertController(with: AlertConstants.messageFailed)
            dismiss(animated: true)
            present(alertController, animated: true)
        @unknown default:
            dismiss(animated: true)
        }
    }
}
