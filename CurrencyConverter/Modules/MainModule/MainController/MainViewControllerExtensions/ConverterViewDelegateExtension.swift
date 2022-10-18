//
//  ConverterViewDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController: ConverterViewDelegate {
    func valueChanged(in textField: inout AdjustableTextField) {
        textField.text = exchangeService.converterModel.transform(textField.text)
        updateCurrentTableView()
    }
    
    func sellBuyButtonTapped() {
        exchangeService.converterModel.isSellAction.toggle()
        updateCurrentTableView()
    }
}
