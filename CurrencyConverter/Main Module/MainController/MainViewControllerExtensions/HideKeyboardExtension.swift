//
//  HideKeyboardExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import UIKit

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
