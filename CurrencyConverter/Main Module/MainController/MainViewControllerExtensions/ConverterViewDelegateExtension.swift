//
//  ConverterViewDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController: ConverterViewDelegate {
    var converterModel: ConverterModel {
        return  ConverterModel.shared
    }
    
    func valueChanged(in textField: inout AdjustableTextField) {
        textField.text = converterModel.transform(textField.text)
        updateCurrentTableView()
    }
    
    func buttonSelected() {
        converterModel.isSellAction.toggle()
        updateCurrentTableView()
    }
}
