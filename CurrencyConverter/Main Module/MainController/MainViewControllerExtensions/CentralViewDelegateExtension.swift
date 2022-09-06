//
//  CentralViewDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import UIKit

extension MainViewController: CentralViewDelegate {
    var messageModel: MessageModel {
        return MessageModel.shared
    }
    
    func swipe() {
        mainView.startSwipeAnimation()
        getExchangeRates()
    }
    
    func addButtonPressed() {
        openCurrencyViewController()
    }
    
    func updateAddButton() {
        mainView.setAddButtonStatus(ratesModel.isMaxNumberOfRows())
    }
    
    func changeCurrency(at row: Int) {
        openCurrencyViewController(for: row)
        }
    
    func shareRatesPressed() {
        let text = messageModel.createMessage()
        let textToShare = [text]
        let activityController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.popoverPresentationController?.permittedArrowDirections = .any
        present(activityController, animated: true, completion: nil)
    }
    
    func dateWasChanged(new date: Date) {
        exchangeRateModel.selectedDate = date.startOfDay
        guard self.dateModel.checkPickerDate(date) else {
            self.updateCurrentTableView()
            return
        }
        if exchangeRateModel.isBulletinInDatabase(for: date) {
            print("Update from Database")
            self.updateCurrentTableView()
        } else {
            self.getExchangeRates(for: date)
        }
    }
}
