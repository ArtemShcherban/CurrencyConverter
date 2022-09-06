//
//  RatesModelDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController: RatesModelDelegate {
    var ratesModel: RatesModel {
        return RatesModel.shared
    }
    
    func updateCurrentTableView() {
        fillDataSource()
        mainView.updateTableView()
        updateAddButton()
    }
}
