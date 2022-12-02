//
//  CentralViewDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import UIKit

extension MainViewController: CentralViewDelegate {
    func swipe() {
        startSwipeAnimation {
            guard self.checkUpdateTime(date: Date()) else { return }
            self.updateData()
        }
    }
    
    func addButtonPressed() {
        openCurrencyViewController()
    }
    
    func updateAddButton() {
        setAddButtonStatus(exchangeService.ratesModel.canAddRow())
    }
    
    func changeCurrency(at row: Int) {
        openCurrencyViewController(for: row)
        }
    
    func shareRates(sender: UIButton) {
        let text = exchangeService.messageModel.createMessage(with: lastUpdateDate)
        let textToShare = [text]
        let activityController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.popoverPresentationController?.sourceRect = sender.frame
        activityController.popoverPresentationController?.permittedArrowDirections = .right
        present(activityController, animated: true, completion: nil)
    }
    
    func dateWasChanged(new date: Date) {
        exchangeService.exchangeRateModel.selectedDate = date.startOfDay
        guard self.exchangeService.dateModel.checkPickerDate(date) else {
            self.updateCurrentTableView()
            return
        }
        if exchangeService.exchangeRateModel.isBulletinInDatabase(for: date) {
            self.updateCurrentTableView()
        } else {
            self.updateData(for: date)
        }
    }
}
