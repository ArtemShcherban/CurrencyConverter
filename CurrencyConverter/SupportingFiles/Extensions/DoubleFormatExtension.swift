//
//  DoubleFormatExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 17.08.2022.
//

import Foundation

extension Double {
    func decimalFormat(_ minimumFractionDigits: Int = 2) -> String {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.groupingSeparator = " "
        formater.maximumFractionDigits = 2
        formater.roundingMode = .halfUp
        formater.minimumFractionDigits = minimumFractionDigits
        return formater.string(for: self) ?? ""
//        return formater.string(from: NSNumber(value: self)) ?? String(0.00)
    }
}
