//
//  MainViewDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController: MainViewDelegate {
    func switchViewButtonPressed() {
        updateCurrentTableView()
    }
}
