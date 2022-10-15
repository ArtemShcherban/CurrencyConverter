//
//  ConverterViewDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController: ConverterViewDelegate {
    func valueChanged(in textField: inout AdjustableTextField) {
        textField.text = mainModel.converter.transform(textField.text)
        updateCurrentTableView()
    }
    
    func sellBuyButtonTapped() {
        mainModel.converter.isSellAction.toggle()
        updateCurrentTableView()
    }
}
