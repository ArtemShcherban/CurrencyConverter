//
//  UIControlExtension.swift
//  CurrencyConverterUnitTests
//
//  Created by Artem Shcherban on 04.11.2022.
//

import UIKit

extension UIControl {
    func simulateTap() {
        sendActions(for: .touchUpInside)
    }
    
    func simulateEditingChanged() {
        sendActions(for: .editingChanged)
    }
}
