//
//  UserDeafaultsError.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 29.07.2022.
//

import Foundation

enum UserDeafaultsError: String, Error {
    case cannotGetData = "Cannot get Data from UserDefaults"
}
